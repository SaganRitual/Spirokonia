// We are a way for the cosmos to know itself. -- C. Sagan

import GameplayKit
import SwiftUI

class TumblerSelectorState: GKState {
    var sm: TumblerSelectorStateMachine { (stateMachine as? TumblerSelectorStateMachine)! }

    var appState: AppState { sm.appState }
    var indexBeingTouched: Int { sm.indexBeingTouched }

    var indexOfDrivingTumbler: Int? {
        get { sm.indexOfDrivingTumbler } set { sm.indexOfDrivingTumbler = newValue }
    }

    var uiChargeState: UIChargeState? {
        get { sm.uiChargeState } set { sm.uiChargeState = newValue }
    }
}

class TumblerSelectorStateBeginPress: TumblerSelectorState {
    override func didEnter(from previousState: GKState?) {
        // Remember which tumbler is in charge of the sliders, if any one is
        uiChargeState = UIChargeState(sm)

        switch appState.tumblerSelectorSwitches[indexBeingTouched] {
        case .trueDefinite:
            appState.tumblerSelectorSwitches[indexBeingTouched] = .trueIndefinite
        case .falseDefinite:
            appState.tumblerSelectorSwitches[indexBeingTouched] = .falseIndefinite
        default:
            fatalError()
        }
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass.self == TumblerSelectorStateEndPress.self ||
        stateClass.self == TumblerSelectorStateLongPressDetected.self
    }
}

class TumblerSelectorStateLongPressDetected: TumblerSelectorState {
    override func didEnter(from previousState: GKState?) {
        for ix in appState.tumblerSelectorSwitches.indices where ix != indexBeingTouched {
            appState.tumblerSelectorSwitches[ix] = .falseDefinite
        }

        appState.tumblerSelectorSwitches[indexBeingTouched] = .trueDefinite
        indexOfDrivingTumbler = indexBeingTouched
        uiChargeState?.charge(sm)
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass.self == TumblerSelectorStateEndPress.self
    }
}

class TumblerSelectorStateEndPress: TumblerSelectorState {
    override func didEnter(from previousState: GKState?) {
        if previousState is TumblerSelectorStateBeginPress {
            switch appState.tumblerSelectorSwitches[indexBeingTouched] {
            case .falseIndefinite:
                appState.tumblerSelectorSwitches[indexBeingTouched] = .trueDefinite
            case .trueIndefinite:
                appState.tumblerSelectorSwitches[indexBeingTouched] = .falseDefinite

                // If we just now deselected the one that was driving the UI, get
                // a new driver
                if let driver = indexOfDrivingTumbler, driver == indexBeingTouched {
                    indexOfDrivingTumbler = appState.tumblerSelectorSwitches.firstIndex { $0.isTracking }
                }
            default:
                fatalError()
            }

            uiChargeState?.charge(sm)
        }

        sm.enter(TumblerSelectorStateQuiet.self)
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass.self == TumblerSelectorStateQuiet.self
    }
}

class TumblerSelectorStateQuiet: TumblerSelectorState {
    override func didEnter(from previousState: GKState?) {
        if previousState == nil {
            indexOfDrivingTumbler = appState.tumblerSelectorSwitches.firstIndex { $0.isTracking }
            uiChargeState = UIChargeState(sm)
        }
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass.self == TumblerSelectorStateBeginPress.self
    }
}

struct UIChargeState {
    let driver: Int?
    let states: [AppState.TumblerSelectorSwitchState]

    init(_ stateMachine: TumblerSelectorStateMachine) {
        self.driver = stateMachine.indexOfDrivingTumbler
        self.states = stateMachine.appState.tumblerSelectorSwitches
    }

    func charge(_ stateMachine: TumblerSelectorStateMachine) {
        // No driver, so clear everything
        if stateMachine.indexOfDrivingTumbler == nil {
            stateMachine.clearUI()
            return
        }

        // We have a driver; if it's the same driver as before, do nothing
        if let oldDriver = driver, let newDriver = stateMachine.indexOfDrivingTumbler,
           oldDriver == newDriver {
            return
        }

        // We have a driver, it's not the same as the driver before the selection
        stateMachine.chargeUI()
    }
}

class TumblerSelectorStateMachine: GKStateMachine, ObservableObject {
    @ObservedObject var appState: AppState
    @ObservedObject var pixoniaScene: PixoniaScene

    var indexBeingTouched = 0
    var indexOfDrivingTumbler: Int?
    var uiChargeState: UIChargeState?

    init(appState: ObservedObject<AppState>, pixoniaScene: ObservedObject<PixoniaScene>) {
        self._appState = appState
        self._pixoniaScene = pixoniaScene

        super.init(states: [
            TumblerSelectorStateBeginPress(),
            TumblerSelectorStateLongPressDetected(),
            TumblerSelectorStateEndPress(),
            TumblerSelectorStateQuiet()
        ])

        enter(TumblerSelectorStateQuiet.self)
    }

    func beginPress(_ index: Int) {
        indexBeingTouched = index
        enter(TumblerSelectorStateBeginPress.self)
    }

    func chargeUI() {
        let pixieIx = indexOfDrivingTumbler! + 1

        appState.innerRingRollMode = pixoniaScene.pixies[pixieIx].rollMode
        appState.showRingInner = pixoniaScene.pixies[pixieIx].showRing
        appState.drawDotsInner = pixoniaScene.pixies[pixieIx].drawDots
        appState.radius = pixoniaScene.pixies[pixieIx].radius
        appState.pen = pixoniaScene.pixies[pixieIx].pen.space.position.r
        appState.density = pixoniaScene.pixies[pixieIx].density
        appState.colorSpeed = pixoniaScene.pixies[pixieIx].colorSpeed
        appState.trailDecay = pixoniaScene.pixies[pixieIx].trailDecay
    }

    func clearUI() {
        indexOfDrivingTumbler = nil

        appState.innerRingRollMode = .fullStop
        appState.showRingInner = false
        appState.drawDotsInner = false
        appState.radius = 0
        appState.pen = 0
        appState.density = 0
        appState.colorSpeed = 0
        appState.trailDecay = 0
    }

    func longPressDetected() {
        enter(TumblerSelectorStateLongPressDetected.self)
    }

    func endPress() {
        enter(TumblerSelectorStateEndPress.self)
    }
}

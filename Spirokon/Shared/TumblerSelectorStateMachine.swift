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
}

class TumblerSelectorStateBeginPress: TumblerSelectorState {
    override func didEnter(from previousState: GKState?) {
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
        sm.chargeUI()
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
            default:
                fatalError()
            }
        }

        sm.enter(TumblerSelectorStateQuiet.self)
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass.self == TumblerSelectorStateQuiet.self
    }
}

class TumblerSelectorStateQuiet: TumblerSelectorState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass.self == TumblerSelectorStateBeginPress.self
    }
}

class TumblerSelectorStateMachine: GKStateMachine, ObservableObject {
    @ObservedObject var appState: AppState
    @ObservedObject var pixoniaScene: PixoniaScene

    var indexBeingTouched = 0
    var indexOfDrivingTumbler: Int?

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
        // Remember which tumbler is in charge of the sliders, if any one is
        if indexOfDrivingTumbler == nil {
            indexOfDrivingTumbler = appState.tumblerSelectorSwitches
                    .firstIndex(where: { $0.isTracking })
        }

        indexBeingTouched = index
        enter(TumblerSelectorStateBeginPress.self)
    }

    func chargeUI() {
        if indexOfDrivingTumbler == nil {
            guard let p = appState.tumblerSelectorSwitches
                    .firstIndex(where: { $0.isTracking }) else { clearUI(); return }

            indexOfDrivingTumbler = p
        } else {
            // Whether other tumblers got selected or deselected, this one was in charge
            // already, so it's still in charge, nothing changes in the sliders.
            if indexBeingTouched == indexOfDrivingTumbler! { return }
        }

        let pixieIx = indexOfDrivingTumbler!

        appState.innerRingRollMode = pixoniaScene.pixies[pixieIx].rollMode
        appState.showRingInner = pixoniaScene.pixies[pixieIx].showRing
        appState.drawDotsInner = pixoniaScene.pixies[pixieIx].drawDots
        appState.radius = pixoniaScene.pixies[pixieIx].radius
        appState.pen = pixoniaScene.pixies[pixieIx].pen
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

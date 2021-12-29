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
}

class TumblerSelectorStateMachine: GKStateMachine, ObservableObject {
    @ObservedObject var appState: AppState

    var indexBeingTouched = 0
    var indexOfDrivingTumbler: Int?

    init(appState: ObservedObject<AppState>) {
        self._appState = appState

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

    func longPressDetected() {
        enter(TumblerSelectorStateLongPressDetected.self)
    }

    func endPress() {
        enter(TumblerSelectorStateEndPress.self)
    }
}

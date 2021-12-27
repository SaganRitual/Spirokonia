// We are a way for the cosmos to know itself. -- C. Sagan

import GameplayKit
import SwiftUI

class TumblerSelectorState: GKState {
    var sm: TumblerSelectorStateMachine { (stateMachine as? TumblerSelectorStateMachine)! }

    var appState: AppState { sm.appState.wrappedValue }
    var indexBeingTouched: Int { sm.indexBeingTouched }
    var indexOfDrivingTumbler: Int? { sm.indexOfDrivingTumbler }

    func chargeUI(_ indexOfDrivingTumbler: Int?) {

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
    override func didEnter(from previousState: GKState?) {
        // We're initializing; charge UI from first selected tumbler
        if previousState == nil {
            let ix = appState.tumblerSelectorSwitches.firstIndex(of: .trueDefinite)
            chargeUI(ix)
        }
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass.self == TumblerSelectorStateBeginPress.self
    }
}

class TumblerSelectorStateMachine: GKStateMachine, ObservableObject {
    var appState: ObservedObject<AppState>
    var indexBeingTouched = 0
    var indexOfDrivingTumbler: Int?

    init(appState: ObservedObject<AppState>) {
        self.appState = appState

        super.init(states: [
            TumblerSelectorStateBeginPress(),
            TumblerSelectorStateLongPressDetected(),
            TumblerSelectorStateEndPress(),
            TumblerSelectorStateQuiet()
        ])

        enter(TumblerSelectorStateQuiet.self)
    }

    func changeLongPress(_ index: Int) {
        indexBeingTouched = index
        enter(TumblerSelectorStateBeginPress.self)
    }

    func endLongPress() {
        enter(TumblerSelectorStateLongPressDetected.self)
    }

    func onTap() {
        enter(TumblerSelectorStateEndPress.self)
    }
}

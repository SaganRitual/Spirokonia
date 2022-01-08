// We are a way for the cosmos to know itself. -- C. Sagan

import GameplayKit
import SwiftUI

class TumblerSelectorState: GKState {
    var sm: TumblerSelectorStateMachine { (stateMachine as? TumblerSelectorStateMachine)! }

    var appModel: AppModel { sm.appModel }
    var indexBeingTouched: Int { sm.indexBeingTouched }

    var indexOfDrivingTumbler: Int? {
        get { sm.indexOfDrivingTumbler } set { sm.indexOfDrivingTumbler = newValue }
    }
}

class TumblerSelectorStateBeginPress: TumblerSelectorState {
    override func didEnter(from previousState: GKState?) {
        switch appModel.tumblerSelectorSwitches[indexBeingTouched] {
        case .trueDefinite:
            appModel.tumblerSelectorSwitches[indexBeingTouched] = .trueIndefinite
        case .falseDefinite:
            appModel.tumblerSelectorSwitches[indexBeingTouched] = .falseIndefinite
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
        // This means the user is long-pressing a button that was already the
        // only one selected. Treat it as a "select all", keeping that one as the driver.
        let longPressOnSoloedButton: Bool = {
            if appModel.tumblerSelectorSwitches[indexBeingTouched] == .trueIndefinite {
                if let currentDriver = indexOfDrivingTumbler,
                   currentDriver == indexBeingTouched,
                   appModel.tumblerSelectorSwitches.filter({ $0.isEngaged }).isEmpty {
                    return true
                }
            }

            return false
        }()

        if longPressOnSoloedButton {
            appModel.tumblerSelectorSwitches.indices.forEach {
                appModel.tumblerSelectorSwitches[$0] = .trueDefinite
            }

            return
        }

        for ix in appModel.tumblerSelectorSwitches.indices where ix != indexBeingTouched {
            appModel.tumblerSelectorSwitches[ix] = .falseDefinite
        }

        appModel.tumblerSelectorSwitches[indexBeingTouched] = .trueDefinite
        indexOfDrivingTumbler = indexBeingTouched
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass.self == TumblerSelectorStateEndPress.self
    }
}

class TumblerSelectorStateEndPress: TumblerSelectorState {
    override func didEnter(from previousState: GKState?) {
        if previousState is TumblerSelectorStateBeginPress {
            switch appModel.tumblerSelectorSwitches[indexBeingTouched] {
            case .falseIndefinite:
                appModel.tumblerSelectorSwitches[indexBeingTouched] = .trueDefinite

                // If no one was selected, set the one being touched as the new driver
                if indexOfDrivingTumbler == nil {
                    indexOfDrivingTumbler = indexBeingTouched
                }
            case .trueIndefinite:
                appModel.tumblerSelectorSwitches[indexBeingTouched] = .falseDefinite

                // If we just now deselected the one that was driving the UI, get
                // a new driver
                if let driver = indexOfDrivingTumbler, driver == indexBeingTouched {
                    indexOfDrivingTumbler = appModel.tumblerSelectorSwitches.firstIndex { $0.isEngaged }
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
            indexOfDrivingTumbler = appModel.tumblerSelectorSwitches.firstIndex { $0.isEngaged }
        }
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        stateClass.self == TumblerSelectorStateBeginPress.self
    }
}

class TumblerSelectorStateMachine: GKStateMachine, ObservableObject {
    @ObservedObject var appModel: AppModel

    var indexBeingTouched = 0
    @Published var indexOfDrivingTumbler: Int?

    init(appModel: AppModel) {
        self._appModel = ObservedObject(initialValue: appModel)

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

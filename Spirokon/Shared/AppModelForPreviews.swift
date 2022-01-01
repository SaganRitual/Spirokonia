// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct AppModelForPreviews {
    @StateObject var appState: AppState
    @StateObject var pixoniaScene: PixoniaScene
    @StateObject var tumblerSelectorStateMachine: TumblerSelectorStateMachine

    init() {
        let state = AppState()
        _appState = StateObject(wrappedValue: state)

        let sm = TumblerSelectorStateMachine(appState: state)
        _tumblerSelectorStateMachine = StateObject(wrappedValue: sm)

        let scene = PixoniaScene(appState: state, tumblerSelectorStateMachine: sm)
        _pixoniaScene = StateObject(wrappedValue: scene)
    }
}

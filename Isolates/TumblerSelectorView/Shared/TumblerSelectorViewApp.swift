// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

@main
struct TumblerSelectorViewApp: App {
    @ObservedObject var appState = AppState()
    @ObservedObject var pixoniaScene: PixoniaScene
    @ObservedObject var tumblerSelectorStateMachine: TumblerSelectorStateMachine

    init() {
        _pixoniaScene = ObservedObject(
            wrappedValue: PixoniaScene(appState: _appState)
        )

        _tumblerSelectorStateMachine = ObservedObject(
            wrappedValue: TumblerSelectorStateMachine(appState: _appState)
        )
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environmentObject(pixoniaScene)
                .environmentObject(tumblerSelectorStateMachine)
        }
    }
}

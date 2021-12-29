// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

@main
struct SpirokonApp: App {
    @ObservedObject var appState = AppState()
    @ObservedObject var pixoniaScene: PixoniaScene
    @ObservedObject var tumblerSelectorStateMachine: TumblerSelectorStateMachine

    init() {
        _pixoniaScene = ObservedObject(initialValue: PixoniaScene(appState: _appState))

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

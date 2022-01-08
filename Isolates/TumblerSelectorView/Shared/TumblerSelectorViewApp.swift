// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

@main
struct TumblerSelectorViewApp: App {
    @ObservedObject var appModel = AppModel()
    @ObservedObject var pixoniaScene: PixoniaScene
    @ObservedObject var tumblerSelectorStateMachine: TumblerSelectorStateMachine

    init() {
        _tumblerSelectorStateMachine = ObservedObject(
            wrappedValue: TumblerSelectorStateMachine(appModel: _appState)
        )

        _pixoniaScene = ObservedObject(
            wrappedValue: PixoniaScene(
                appModel: _appState, tumblerSelectorStateMachine: _tumblerSelectorStateMachine
            )
        )
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appModel)
                .environmentObject(pixoniaScene)
                .environmentObject(tumblerSelectorStateMachine)
        }
    }
}

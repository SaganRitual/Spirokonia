// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

@main
struct SpirokonApp: App {
    @ObservedObject var appState = AppState()
    @ObservedObject var pixoniaScene: PixoniaScene

    init() {
        _pixoniaScene = ObservedObject(initialValue: PixoniaScene(appState: _appState))
    }

    var body: some Scene {
        WindowGroup {
            ContentView(appState: appState, pixoniaScene: pixoniaScene)
        }
    }
}

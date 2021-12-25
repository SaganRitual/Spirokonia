// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

@main
struct PixoniaApp: App {
    @ObservedObject var appState = AppState()
    @ObservedObject var pixoniaScene: PixoniaScene

    init() {
        _pixoniaScene = ObservedObject(initialValue: PixoniaScene(appState: _appState))
    }

    var body: some Scene {
        WindowGroup {
            PixoniaAppView(appState: appState, pixoniaScene: pixoniaScene)
        }
    }
}

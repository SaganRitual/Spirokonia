// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

@main
struct SmootherApp: App {
    @ObservedObject var appState = AppState()
    @ObservedObject var pixoniaScene: PixoniaScene

    init() {
        _pixoniaScene = ObservedObject(wrappedValue: PixoniaScene(appState: _appState))
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environmentObject(pixoniaScene)
        }
    }
}

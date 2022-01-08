// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

@main
struct SmootherApp: App {
    @ObservedObject var appModel = AppModel()
    @ObservedObject var pixoniaScene: PixoniaScene

    init() {
        _pixoniaScene = ObservedObject(wrappedValue: PixoniaScene(appModel: _appState))
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appModel)
                .environmentObject(pixoniaScene)
        }
    }
}

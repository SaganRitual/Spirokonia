// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

@main
struct PixoniaApp: App {
    @ObservedObject var appModel = AppModel()
    @ObservedObject var pixoniaScene: PixoniaScene

    init() {
        _pixoniaScene = ObservedObject(initialValue: PixoniaScene(appModel: _appState))
    }

    var body: some Scene {
        WindowGroup {
            PixoniaAppView(appModel: appModel, pixoniaScene: pixoniaScene)
        }
    }
}

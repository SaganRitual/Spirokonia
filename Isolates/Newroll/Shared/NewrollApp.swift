// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

@main
struct NewrollApp: App {
    var pixoniaScene: PixoniaScene

    init() {
        pixoniaScene = PixoniaScene()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(pixoniaScene)
        }
    }
}

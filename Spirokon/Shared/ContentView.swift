// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var pixoniaScene: PixoniaScene

    var body: some View {
        HStack {
            MainNavigationView()
            PixoniaView(appState: appState, scene: pixoniaScene)
        }
    }
}

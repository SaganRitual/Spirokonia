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

struct ContentView_Previews: PreviewProvider {
    @ObservedObject static var appState = AppState()
    static var previews: some View {
        ContentView(appState: AppState(), pixoniaScene: PixoniaScene(appState: _appState))
            .previewInterfaceOrientation(.landscapeRight)
    }
}

// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var pixoniaScene: PixoniaScene

    var body: some View {
        HStack {
            TabView {
                MainNavigationView()
                    .tabItem { Label("Dashboard", systemImage: "speedometer") }

                PensView()
                    .tabItem { Label("Pens", systemImage: "rectangle.and.pencil.and.ellipsis") }
            }

            PixoniaView(appState: appState, scene: pixoniaScene)
        }
    }
}

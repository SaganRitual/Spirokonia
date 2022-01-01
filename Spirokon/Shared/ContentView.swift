// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var pixoniaScene: PixoniaScene

    var body: some View {
        NavigationView {
            VStack {
                Spacer()

                Section("Main") {
                    TumblerSettingsViewOuter()
                }

                Spacer()

                Section("Tumblers") {
                    TumblerSelectorView()
                    TumblerSettingsViewInner()
                }

                Spacer()
            }
            .navigationTitle("Spirokon v0.2")
            .padding(.horizontal)

            PixoniaView(scene: pixoniaScene)
        }
    }
}

// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appModel: AppModel
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

                SaveLoad()

                Spacer()
            }
            .navigationTitle("SpiroZen")
            .padding(.horizontal)

            PixoniaView(scene: pixoniaScene)
        }
    }
}

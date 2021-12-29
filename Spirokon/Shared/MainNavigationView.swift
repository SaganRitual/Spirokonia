// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct MainNavigationView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var pixoniaScene: PixoniaScene

    var body: some View {
        NavigationView {
            VStack {
                Spacer()

                Section(AppState.showTextLabels ? "App" : "") {
                    TumblerSettingsViewMain()
                }

                Spacer()

                Section(AppState.showTextLabels ? "Main Ring" : "") {
                    TumblerSettingsViewOuter()
                }

                Spacer()

                Section(AppState.showTextLabels ? "Inner Rings" : "") {
                    TumblerSelectorView()
                        .padding(.top)
                }

                Spacer()

                Section {
                    TumblerSettingsViewInner()
                }

                Spacer()
            }
            .navigationTitle("Settings")
            .padding([.leading, .trailing])
        }
        #if os(iOS)
        .navigationViewStyle(StackNavigationViewStyle())
        #endif
    }
}

struct MainNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        MainNavigationView()
    }
}

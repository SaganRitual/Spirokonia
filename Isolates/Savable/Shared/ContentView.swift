// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appModel: AppModel

    var body: some View {
        VStack {
            NavigationView {
                VStack {
                    Spacer()

                    Section("Main Ring") {
                        TumblerSettingsViewOuter()
                    }

                    Spacer()

                    Section("Drawing Rings") {
                        TumblerSelectorView()
                        TumblerSettingsViewInner()
                    }

                    Spacer()

                    SaveLoad()

                    Spacer()
                }
                .navigationTitle("SpinZen")
                .padding(.horizontal)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

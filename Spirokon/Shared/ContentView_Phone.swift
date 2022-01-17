// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct ContentView_Phone: View {
    var body: some View {
        TabView {
            TumblerSettingsViewOuter().tabItem { Image(systemName: "speedometer") }

            VStack {
                TumblerSelectorView()
                TumblerSettingsViewInner1()
            }.tabItem { Image(systemName: "goforward.plus") }

            VStack {
                TumblerSelectorView()
                TumblerSettingsViewInner2()
            }.tabItem { Image(systemName: "pencil") }

            VStack {
                TumblerSelectorView()
                TumblerSettingsViewInner3()
            }.tabItem { Image(systemName: "rectangle.and.pencil.and.ellipsis") }

            SaveLoad().tabItem { Image(systemName: "square.and.arrow.down") }
        }
    }
}

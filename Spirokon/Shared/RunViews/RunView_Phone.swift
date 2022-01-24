// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct RunView_Phone: View {
    var body: some View {
        TabView {
            TumblerSettingsViewOuter().tabItem { Image(systemName: "speedometer") }

            VStack {
                TumblerSelectorView()
                TumblerSettingsViewInner()
            }.tabItem { Image(systemName: "pencil") }

            SaveLoad().tabItem { Image(systemName: "square.and.arrow.down") }
        }
    }
}

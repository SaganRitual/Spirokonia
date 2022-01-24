// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var deviceOrientation: DeviceOrientation

    @Binding var showWelcomeScreen: Bool

    var body: some View {
        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .phone {
            if deviceOrientation.orientation == .landscape {
                WelcomeView_HPhone(showWelcomeScreen: $showWelcomeScreen)
            } else {
                WelcomeView_VPhone(showWelcomeScreen: $showWelcomeScreen)
            }
        } else {
            WelcomeView_VPhone(showWelcomeScreen: $showWelcomeScreen)
        }
        #elseif os(macOS)

        #else
        #error("Not supported")
        #endif
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(showWelcomeScreen: .constant(true))
    }
}

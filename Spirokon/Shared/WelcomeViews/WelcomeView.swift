// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct WelcomeView: View {
    #if os(iOS)
    @StateObject private var deviceOrientation = DeviceOrientation()
    #endif

    var body: some View {
        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .phone {
            if deviceOrientation.orientation == .landscape {
                WelcomeView_HPhone()
            } else {
                WelcomeView_VPhone()
            }
        } else {
            WelcomeView_VPhone()
        }
        #elseif os(macOS)

        #else
        #error("Not supported")
        #endif
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}

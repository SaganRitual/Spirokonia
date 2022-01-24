// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct RunView: View {
    @EnvironmentObject var deviceOrientation: DeviceOrientation

    var body: some View {
        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .phone {
            if
                deviceOrientation.orientation == .landscape {
                RunView_HPhone()
            } else {
                RunView_VPhone()
            }
        } else {
            if deviceOrientation.orientation == .landscape {
                RunView_HBig()
            } else {
                RunView_VPhone()
            }
        }
        #elseif os(macOS)
        RunView_HBig()
        #else
        #error("Not supported")
        #endif
    }
}

struct RunView_Previews: PreviewProvider {
    static var previews: some View {
        RunView()
    }
}

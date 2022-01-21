// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct HelpView: View {
    var body: some View {
        Image("help-view").resizable().background(Color.black)
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}

// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct HelpView: View {
    var body: some View {
        VStack {
            Image("main-controls").resizable()
            Image("tumbler-controls").resizable()
            Image("save-load").resizable()
        }
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}

// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct ContentView: View {
    @Binding var showWelcomeScreen: Bool

    var body: some View {
        if showWelcomeScreen {
            WelcomeView(showWelcomeScreen: $showWelcomeScreen)
        } else {
            RunView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(showWelcomeScreen: .constant(true))
    }
}

// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct WelcomeView_HPhone: View {
    @Binding var showWelcomeScreen: Bool

    var body: some View {
        WelcomeView_Phone(showWelcomeScreen: $showWelcomeScreen)
            .offset(x: 150)
            .foregroundColor(.white)
            .background(
                Image("welcome-background")
                    .offset(x: -150, y: -50)
                    .rotationEffect(.radians(-.pi / 6))
            )
    }
}

struct WelcomeView_HPhone_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView_HPhone(showWelcomeScreen: .constant(true))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

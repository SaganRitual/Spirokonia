// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct WelcomeView_VPhone: View {
    @Binding var showWelcomeScreen: Bool

    var body: some View {
        WelcomeView_Phone(showWelcomeScreen: $showWelcomeScreen)
            .offset(y: 150)
            .foregroundColor(.white)
            .background(
                Image("welcome-background")
                    .offset(y: -150)
            )
    }
}

struct WelcomeView_VPhone_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView_VPhone(showWelcomeScreen: .constant(true))
    }
}

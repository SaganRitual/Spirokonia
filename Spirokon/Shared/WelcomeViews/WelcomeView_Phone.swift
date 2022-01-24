// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct WelcomeView_Phone: View {
    @State private var showWelcomeScreen = true

    var body: some View {
        VStack {
            Text("Welcome to SpiroZen 1.1")
                .padding(.bottom)

            Text("You'll feel a lot more Zen if we show you how to use the app.")
            Text("To view a quick \"How To\" video, tap the video play icon below:")
                .padding(.bottom)

            Link(
                destination: URL(string: "https://saganritual.github.io/spirozen-classic-getting-started/")!,
                label: { Image(systemName: "play.rectangle.fill") }
            ).padding(.bottom)

            Text("You can also find the video play icon near the")

            HStack {
                Text("quick help icon ")
                Image(systemName: "questionmark.circle").padding(.trailing, 5)
                Text("on the main screen.")
            }
            .padding(.bottom)

            Text("Or if you're running on iPad in landscape mode,")
            Text("tap the link at the bottom of the navigation sidebar")
            .padding(.bottom)

            Button(
                action: {
                    showWelcomeScreen.toggle()

                    let encoder = JSONEncoder()
                    do {
                        let json = try encoder.encode(showWelcomeScreen)
                        UserDefaults.standard.set(json, forKey: "showWelcomeScreen")
                    } catch {

                    }
                }, label: {
                    HStack {
                        Image(systemName: showWelcomeScreen ? "square" : "checkmark.square")
                        Text("Don't show this welcome screen again")
                    }
                }
            )
        }
    }
}

struct WelcomeView_Phone_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView_Phone()
    }
}

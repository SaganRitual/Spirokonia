// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct ContentView: View {
    func showWelcomeScreen() -> Bool {
        if let loaded = UserDefaults.standard.data(forKey: "showWelcomeScreen") {
            if let showWelcomeScreen = try? JSONDecoder().decode(Bool.self, from: loaded) {
                return showWelcomeScreen
            }
        }

        return true
    }

    var body: some View {
        if showWelcomeScreen() {
            WelcomeView()
        } else {
            RunView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

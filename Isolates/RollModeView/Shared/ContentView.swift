// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct ContentView: View {
    @ObservedObject var appState = AppState()

    var body: some View {
        VStack {
            RollModePicker(ring: .outerRing, rollMode: $appState.outerRingRollMode)
            RollModePicker(ring: .innerRing, rollMode: $appState.innerRingRollMode)
        }
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

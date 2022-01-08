// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct ContentView: View {
    @ObservedObject var appModel = AppModel()

    var body: some View {
        VStack {
            RollModePicker(ring: .outerRing, rollMode: $appModel.outerRingRollMode)
            RollModePicker(ring: .innerRing, rollMode: $appModel.innerRingRollMode)
        }
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

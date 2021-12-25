// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct ContentView: View {
    @ObservedObject var appState = AppState()

    var body: some View {
        VStack {
            TogglesView(ring: .outerRing, drawDots: $appState.drawDotsOuter, showRing: $appState.showRingOuter)
            TogglesView(ring: .innerRing, drawDots: $appState.drawDotsInner, showRing: $appState.showRingInner)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

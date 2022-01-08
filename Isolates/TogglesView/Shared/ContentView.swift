// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct ContentView: View {
    @ObservedObject var appModel = AppModel()

    var body: some View {
        VStack {
            TogglesView(ring: .outerRing, drawDots: $appModel.drawDotsOuter, showRing: $appModel.showRingOuter)
            TogglesView(ring: .innerRing, drawDots: $appModel.drawDotsInner, showRing: $appModel.showRingInner)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct ContentView_VPhone: View {
    @EnvironmentObject var appModel: AppModel
    @EnvironmentObject var pixoniaScene: PixoniaScene

    @State private var showUI = false

    var body: some View {
        VStack {
            PixoniaView(scene: pixoniaScene)

            if showUI {
                ContentView_Phone().transition(.move(edge: .bottom))
            }

            Button(
                action: { withAnimation { showUI.toggle() } },
                label: { Image(systemName: showUI ? "chevron.down" : "chevron.up") }
            )
        }
    }
}

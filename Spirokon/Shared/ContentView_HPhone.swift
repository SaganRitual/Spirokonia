// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct ContentView_HPhone: View {
    @EnvironmentObject var appModel: AppModel
    @EnvironmentObject var pixoniaScene: PixoniaScene

    @State private var showUI = false

    var body: some View {
        HStack {
            Button(
                action: { withAnimation { showUI.toggle() } },
                label: { Image(systemName: showUI ? "chevron.left" : "chevron.right") }
            )

            if showUI {
                ContentView_Phone().transition(.move(edge: .leading))
            }

            PixoniaView(scene: pixoniaScene)
        }
    }
}

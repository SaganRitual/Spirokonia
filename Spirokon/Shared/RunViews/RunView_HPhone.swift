// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct RunView_HPhone: View {
    @EnvironmentObject var appModel: AppModel
    @EnvironmentObject var pixoniaScene: PixoniaScene

    @State private var showQuickHelp = false
    @State private var showUI = false

    var body: some View {
        HStack {
            VStack {
                Button(
                    action: { withAnimation {
                        showUI.toggle()
                        if !showUI { showQuickHelp = false }
                    } },
                    label: { Image(systemName: showUI ? "chevron.left" : "chevron.right") }
                )
                .padding(.bottom)

                Button(
                    action: { withAnimation {
                        showQuickHelp.toggle()
                        if showQuickHelp { showUI = true }
                    } },
                    label: { Image(systemName: "questionmark.circle") }
                )
                .padding(.bottom)

                Link(
                    destination: URL(string: "https://saganritual.github.io/spirozen-classic-getting-started/")!,
                    label: { Image(systemName: "play.rectangle.fill") }
                )
            }

            if showUI {
                RunView_Phone().transition(.move(edge: .leading))
            }

            if showQuickHelp {
                HelpView().transition(.move(edge: .leading))
            } else {
                PixoniaView(scene: pixoniaScene)
            }
        }
    }
}

// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct RunView_VPhone: View {
    @EnvironmentObject var appModel: AppModel
    @EnvironmentObject var pixoniaScene: PixoniaScene

    @State private var showQuickHelp = false
    @State private var showUI = false

    var body: some View {
        VStack {
            if showQuickHelp {
                HelpView().transition(.move(edge: .bottom))
            } else {
                PixoniaView(scene: pixoniaScene)
            }

            if showUI {
                RunView_Phone().transition(.move(edge: .bottom))
            }

            HStack {
                Button(
                    action: { withAnimation {
                        showUI.toggle()
                        if !showUI { showQuickHelp = false }
                    } },
                    label: { Image(systemName: showUI ? "chevron.down" : "chevron.up").padding(.bottom) }
                )
                .padding(.trailing)

                Button(
                    action: { withAnimation {
                        showQuickHelp.toggle()
                        if showQuickHelp { showUI = true }
                    } },
                    label: { Image(systemName: "questionmark.circle") }
                )
                .padding(.trailing)

                Link(
                    destination: URL(string: "https://saganritual.github.io/spirozen-classic-getting-started/")!,
                    label: { Image(systemName: "play.rectangle.fill") }
                )
            }
        }
    }
}

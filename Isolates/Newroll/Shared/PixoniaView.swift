// We are a way for the cosmos to know itself. -- C. Sagan

import SpriteKit
import SwiftUI

struct PixoniaView: View {
    let scene: PixoniaScene

    #if DEBUG
    let debugOptions: SpriteView.DebugOptions = [.showsFPS, .showsNodeCount]
    #else
    let debugOptions: SpriteView.DebugOptions = []
    #endif

    var body: some View {
        SpriteView(
            scene: scene,
            options: [.ignoresSiblingOrder, .shouldCullNonVisibleNodes],
            debugOptions: debugOptions
        )
        .aspectRatio(1.0, contentMode: .fit)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

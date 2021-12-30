// We are a way for the cosmos to know itself. -- C. Sagan

import SpriteKit
import SwiftUI

struct PixoniaView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var pixoniaScene: PixoniaScene

    var body: some View {
        SpriteView(
            scene: pixoniaScene,
            options: SpriteView.Options(),
            debugOptions: [.showsFPS, .showsNodeCount, .showsDrawCount, .showsQuadCount]
        )
        .aspectRatio(1.0, contentMode: .fit)
    }
}

// We are a way for the cosmos to know itself. -- C. Sagan

import SpriteKit
import SwiftUI

struct PixoniaView: View {
    @ObservedObject var appState: AppState
    let scene: PixoniaScene

    var body: some View {
        SpriteView(
            scene: scene,
            options: SpriteView.Options(),
            debugOptions: [.showsFPS, .showsNodeCount, .showsDrawCount, .showsQuadCount]
        )
        .aspectRatio(1.0, contentMode: .fill)
    }
}

// We are a way for the cosmos to know itself. -- C. Sagan

import SpriteKit
import SwiftUI

struct PixoniaView: View {
    let scene: PixoniaScene

    var body: some View {
        SpriteView(
            scene: scene,
            options: SpriteView.Options(),
            debugOptions: [.showsFPS, .showsNodeCount, .showsDrawCount, .showsQuadCount]
        )
        .aspectRatio(1.0, contentMode: .fit)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct PixoniaView_Previews: PreviewProvider {
    static let appModel = PreviewsObject()

    static var previews: some View {
        PixoniaView(scene: appModel.pixoniaScene)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

// We are a way for the cosmos to know itself. -- C. Sagan

import SpriteKit
import SwiftUI

class PixoniaScene: SKScene, SKSceneDelegate, ObservableObject {
    @ObservedObject var appState: AppState

    let mainControl = MainControl()
    let outerRing = OuterRing()
    let innerRings: [InnerRing]

    init(appState: ObservedObject<AppState>) {
        self._appState = appState

        self.innerRings = (1..<5).map { InnerRing(.innerRing($0)) }

        super.init(size: CGSize(width: 1024, height: 1024))

        self.anchorPoint = .anchorAtCenter
        self.scaleMode = .aspectFit
        self.backgroundColor = .black

        self.addChild(mainControl.pixieProxy.skNode)
        self.addChild(outerRing.pixieProxy.skNode)
        self.innerRings.forEach { [weak self] in self?.addChild($0.pixieProxy.skNode) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

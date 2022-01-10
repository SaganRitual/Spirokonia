// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import SpriteKit
import SwiftUI

class PixoniaScene: SKScene, SKSceneDelegate, ObservableObject {
    let radius: Double = 1024

    var previousTime: TimeInterval?
    var pixieHarness: PixieHarness!

    override init() {
        super.init(size: CGSize(width: radius * 2, height: radius * 2))

        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.scaleMode = .aspectFit
        self.backgroundColor = .black

        pixieHarness = PixieHarness(self)
    }

    override func update(_ currentTime: TimeInterval) {
        defer { previousTime = currentTime }
        guard let previousTime = previousTime else { return }
        let deltaTime = currentTime - previousTime

        pixieHarness.update(deltaTime)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

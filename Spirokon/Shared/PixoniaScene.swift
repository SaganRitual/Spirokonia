// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import SpriteKit
import SwiftUI

class PixoniaScene: SKScene, SKSceneDelegate, ObservableObject {
    @ObservedObject var appState: AppState

    var previousTime: TimeInterval?

    var pixies = [Pixie]()

    init(appState: ObservedObject<AppState>) {
        _appState = appState

        super.init(size: CGSize(width: 1024, height: 1024))

        self.anchorPoint = .anchorAtCenter
        self.scaleMode = .aspectFill
        self.backgroundColor = .black
    }

    override func didMove(to view: SKView) {
        for p in 0..<5 {
            let ring: AppState.Ring
            let parent: SKNode

            if p == 0 {
                ring = .outerRing
                parent = self
            } else {
                ring = .innerRing(p)
                parent = pixies.last!.sprite
            }

            let pixie = Pixie(ring, parent: parent)
            pixie.sprite.size = self.size
            pixie.sprite.setScale(pixie.radius)

            pixie.sprite.position = p == 0 ? .zero :
                CGPoint(x: (pixies[0].sprite.size.width - pixie.sprite.size.width) / 2, y: 0)

            pixie.postInit(appState: _appState)
            pixie.color = SKColor([Color.red, Color.green, Color.blue, Color.yellow, Color.orange][p])

            pixies.append(pixie)
        }
    }

    override func update(_ currentTime: TimeInterval) {
        defer { previousTime = currentTime }
        guard let previousTime = previousTime else { return }
        let deltaTime_ = currentTime - previousTime
        let deltaTime = min(deltaTime_, 1.0 / 60.0)

        var direction = -1.0
        var totalScale = 1.0

        for pixie in pixies {
            pixie.applyUIState()

            direction *= -1
            totalScale *= pixie.radius

            pixie.dropDot(onto: self)

            pixie.roll(2.0 * .pi * direction / totalScale * deltaTime * appState.cycleSpeed)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

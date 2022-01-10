// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import SpriteKit

class Pixie {
    let color: SKColor
    let pixoniaScene: PixoniaScene
    let sprite: SKSpriteNode

    var radiusAnimator: Animator<Pixie>!
    var radiusObserver: AnyCancellable!
    var radiusPublisher: Published<Double>.Publisher!

    var hotRadius = 0.5

    init(radius: Double, color: SKColor, skParent: SKNode, pixoniaScene: PixoniaScene) {
        self.pixoniaScene = pixoniaScene

        sprite = SpritePool.singleSpokeRingsLarge.makeSprite()
        sprite.size = pixoniaScene.size
        sprite.color = color
        sprite.setScale(radius)

        self.color = color
        skParent.addChild(sprite)
    }

    func advance(by rotation: Double) {
        sprite.zRotation += rotation
        sprite.setScale(hotRadius)

        sprite.position = CGPoint(x: pixoniaScene.size.width / 2.0 * (1.0 - hotRadius), y: 0)
    }

    func postInit(_ appModel: AppModel) {
        assert(
            radiusPublisher != nil,
            "Child classes must instantiate the publisher before coming here"
        )

        radiusAnimator = Animator(\.hotRadius, for: self)

        radiusObserver =
            radiusPublisher.sink {
                [weak self] newRadius in guard let myself = self else { return }
                myself.radiusAnimator.animate(to: newRadius)
            }
    }

    func update(deltaTime: Double) {
        guard let radiusAnimator = radiusAnimator else { return }
        radiusAnimator.update(deltaTime: deltaTime / AppDefinitions.animationsDuration)
    }
}

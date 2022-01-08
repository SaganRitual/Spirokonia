// We are a way for the cosmos to know itself. -- C. Sagan

import SpriteKit

class Nib {
    let sprite: SKSpriteNode
    var space = UCSpace.unit

    init(color: SKColor, skParent: SKNode, ucParent: UCSpace) {
        sprite = SpritePool.dots.makeSprite()
        sprite.size = CGSize(width: 50, height: 50)
        sprite.color = color

        skParent.addChild(sprite)
        ucParent.addChild(space)
    }
}

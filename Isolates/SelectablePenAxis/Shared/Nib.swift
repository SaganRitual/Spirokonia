// We are a way for the cosmos to know itself. -- C. Sagan

import SpriteKit

class Nib {
    let sprite: SKSpriteNode
    var space = UCSpace.unit

    init(skParent: SKNode, ucParent: UCSpace) {
        sprite = SpritePool.dots.makeSprite()
        sprite.size = CGSize(width: 50, height: 50)
        sprite.color = [.red, .green, .blue, .cyan, .magenta, .yellow, .purple].randomElement()!

        skParent.addChild(sprite)
        ucParent.addChild(space)
    }

    func reify(to ancestorSpace: UCSpace) {
        sprite.position = ancestorSpace.emplace(space).cgPoint
        sprite.zPosition = 3
    }
}

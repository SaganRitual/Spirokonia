// We are a way for the cosmos to know itself. -- C. Sagan

import SpriteKit

class PixieConnector {
    let space: UCSpace
    let sprite: SKSpriteNode

    let nib: Nib

    weak var mePixie: Pixie?
    weak var toPixie: Pixie?

    init(from fromPixie: Pixie, to toPixie: Pixie, skParent: SKNode, ucParent: UCSpace) {
        self.mePixie = fromPixie
        self.toPixie = toPixie

        self.space = UCSpace.unit
        ucParent.addChild(self.space)

        self.sprite = SpritePool.lines.makeSprite()
        skParent.addChild(self.sprite)

        self.nib = Nib(skParent: self.sprite, ucParent: self.space)

        sprite.anchorPoint = .anchorDueWest
        sprite.color = .green
        sprite.size.height = 3
    }

    func reify(to ancestorSpace: UCSpace) {
        var toPosition = ancestorSpace.emplace(toPixie!.textureSpace)

        // Connector to myself is a line from my center to my (1.0, 0.0).
        // The rest of the connectors are from my center to each descendants' center
        if mePixie === toPixie {
            toPosition.r += ancestorSpace.ensize(mePixie!.textureSpace).radius
        }

        let fromPosition = ancestorSpace.emplace(mePixie!.textureSpace)
        let distance = fromPosition.distance(to: toPosition)
        let difference = toPosition - fromPosition

        sprite.position = fromPosition.cgPoint
        sprite.size.width = distance

        if toPixie === mePixie {
            space.rotation = 0  // Special connector always acts unrotated
            sprite.zRotation = mePixie!.textureSpace.rotation
        } else {
            space.rotation = atan2(difference.y, difference.x)
            sprite.zRotation = space.rotation
        }

        nib.sprite.position.x = distance * nib.space.position.r
    }
}

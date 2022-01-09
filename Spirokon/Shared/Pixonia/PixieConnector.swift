// We are a way for the cosmos to know itself. -- C. Sagan

import SpriteKit

class PixieConnector {
    let space: UCSpace
    let sprite: SKSpriteNode

    let nib: Nib

    weak var mePixie: DrawingPixie?
    weak var toPixie: DrawingPixie?

    init(color: SKColor, from fromPixie: DrawingPixie, to toPixie: DrawingPixie, skParent: SKNode, ucParent: UCSpace) {
        self.mePixie = fromPixie
        self.toPixie = toPixie

        self.space = UCSpace.unit
        ucParent.addChild(self.space)

        self.sprite = SpritePool.lines.makeSprite()
        skParent.addChild(self.sprite)

        self.nib = Nib(color: color, skParent: self.sprite, ucParent: self.space)

        sprite.anchorPoint = .anchorDueWest
        sprite.color = color
        sprite.size.height = 5
    }

    func reify(to ancestorSpace: UCSpace) {
        var toPosition = ancestorSpace.emplace(toPixie!.core.sprite.space)

        // Connector to myself is a line from my center to my (1.0, 0.0).
        // The rest of the connectors are from my center to each descendants' center
        if mePixie === toPixie {
            toPosition.r += ancestorSpace.ensize(mePixie!.core.sprite.space).radius
        }

        let fromPosition = ancestorSpace.emplace(mePixie!.core.sprite.space)
        let distance = fromPosition.distance(to: toPosition)
        let difference = toPosition - fromPosition

        sprite.position = fromPosition.cgPoint
        sprite.size.width = distance

        if toPixie === mePixie {
            space.rotation = 0  // Special connector always acts unrotated
            sprite.zRotation = mePixie!.core.sprite.space.rotation
        } else {
            space.rotation = atan2(difference.y, difference.x)
            sprite.zRotation = space.rotation
        }

        nib.sprite.position.x = distance * nib.space.position.r
    }
}

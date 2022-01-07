// We are a way for the cosmos to know itself. -- C. Sagan

import SpriteKit

class Pixie {
    let sprite: SKSpriteNode
    let textureSpace: UCSpace

    var connectors = [PixieConnector]()

    var skParent: SKNode { sprite.parent! }
    var ucParent: UCSpace { textureSpace.parent! }

    var penAxis = 0

    init(textureRadius: Double, skParent: SKNode, ucParent: UCSpace) {
        textureSpace = UCSpace(radius: textureRadius)
        ucParent.addChild(textureSpace)

        sprite = SpritePool.crosshairRingsLarge.makeSprite()
        skParent.addChild(sprite)

        sprite.color = .yellow
    }

    func reify(to ancestorSpace: UCSpace) {
        sprite.position = ancestorSpace.emplace(textureSpace).cgPoint
        sprite.size = ancestorSpace.ensize(textureSpace).cgSize
        sprite.zRotation = textureSpace.rotation

        if !connectors.isEmpty {
            connectors[penAxis].reify(to: ancestorSpace)
        }
    }

    func connect(to pixies: [Pixie]) {
        connectors.append(PixieConnector(
            from: self, to: self, skParent: sprite.scene!, ucParent: textureSpace
        ))

        connectors.append(contentsOf: pixies.map { otherPixie in
            PixieConnector(
                from: self, to: otherPixie, skParent: sprite.scene!, ucParent: textureSpace
            )
        })
    }
}

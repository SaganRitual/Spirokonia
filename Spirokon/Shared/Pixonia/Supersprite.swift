// We are a way for the cosmos to know itself. -- C. Sagan

import SpriteKit

class Supersprite {
    private let sprite: SKSpriteNode

    var space = UCSpace()

    var color: SKColor {
        get { sprite.color } set { sprite.color = newValue }
    }

    var radius: Double {
        get { space.radius } set { space.radius = newValue }
    }

    var ucParent: UCSpace { space.parent! }
    var skParent: SKNode { sprite.parent! }

    init(_ pool: SpritePool, color: SKColor, zIndex: Int) {
        sprite = pool.makeSprite()
        sprite.color = color
        sprite.zPosition = Double(zIndex)
    }

    func postInit(skParent: PixoniaScene, ucParent: UCSpace) {
        skParent.addChild(self.sprite)
        ucParent.addChild(self.space)
    }
}

extension Supersprite {
    struct RSnapshot {
        let position: CGPoint
        let rotation: Double
        let size: CGSize
    }
}

extension Supersprite {
    func makeSnapshot() -> RSnapshot {
        RSnapshot(position: sprite.position, rotation: sprite.zRotation, size: sprite.size)
    }

    func reify(to ancestorSpace: UCSpace) {
        sprite.position = ancestorSpace.emplace(space).cgPoint
        sprite.size = ancestorSpace.ensize(space).cgSize
        sprite.zRotation = space.rotation
    }
}

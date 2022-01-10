// We are a way for the cosmos to know itself. -- C. Sagan

import SpriteKit

class Supersprite {
    private let sprite: SKSpriteNode

    let space: UCSpace

    var color: SKColor {
        get { sprite.color } set { sprite.color = newValue }
    }

    var radius: Double {
        get { space.radius } set { space.radius = newValue }
    }

    var ucParent: UCSpace { space.parent! }
    var skParent: SKNode { sprite.parent! }

    init(_ pool: SpritePool, color: SKColor, zIndex: Int, spaceName: String) {
        space = UCSpace(name: spaceName)
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

    func reify(to ancestorSpace: UCSpace, debugShow: Bool) {
        sprite.position = ancestorSpace.emplace(space).cgPoint
        sprite.size = ancestorSpace.ensize(space).cgSize
        sprite.zRotation = -space.position.t

        if debugShow {
            print("reify ss \(space.position)", terminator: "")

            var sp_: UCSpace? = space.parent
            while let sp = sp_ {
                print(" -> \(sp.emplace(space))".replacingOccurrences(of: "UCPoint", with: "UCP"), terminator: "")
                sp_ = sp.parent
            }

            print()
        }
    }
}

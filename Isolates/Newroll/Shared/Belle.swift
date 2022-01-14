// We are a way for the cosmos to know itself. -- C. Sagan

import SpriteKit

class DrawingBelle: Belle {
}

class PlatterBelle: Belle {
    override func jacobsthal() -> Double { radius }
}

class Belle: UCSpace {
    private let sprite: SKSpriteNode
    private let textureScale: Double

    let suppressScaling: Bool

    var rollMode = AppDefinitions.RollMode.cycloid

    var color: SKColor {
        get { sprite.color } set { sprite.color = newValue }
    }

    var reifiedPosition: CGPoint { sprite.position }

    init(pixoniaScene: PixoniaScene, spritePool: SpritePool, suppressScaling: Bool = false) {
        self.suppressScaling = suppressScaling

        sprite = spritePool.makeSprite()
        pixoniaScene.addChild(sprite)

        let textureRadius = spritePool.texture.size().width / 2
        textureScale = textureRadius / pixoniaScene.radius

        super.init(name: "Belle space")
    }

    func getAncestors() -> [Double] {
        var space: UCSpace? = self
        var theArray = [0.0]

        repeat {
            theArray.insert(space!.radius, at: 1)
            space = space?.parent
        } while space != nil

        for ix in 2..<theArray.count {
            theArray[ix] *= 2.0 * (2.0 * theArray[ix - 2] + theArray[ix - 1])
        }

        return theArray
    }

    func jacobsthal() -> Double {
        getAncestors().last!
    }

    func advance(
        by deltaTime: Double, masterCycleSpeed: Double, scale: Double, direction: Double,
        compensation: Double = 0.0
    ) {
        let naturalRotation = deltaTime * masterCycleSpeed * direction * .tau

        switch rollMode {
        case .compensate:
            rotation += 0
        case .cycloid:
            rotation += naturalRotation * scale + compensation
        case .doesNotRoll:
            return
        case .fullStop:
            rotation += 0
        case .sticky:
            rotation += naturalRotation * direction
        case .flattened:
            rotation += naturalRotation * scale
        }

        for child in children.compactMap({ $0 as? Belle }) {
            child.advance(
                by: deltaTime, masterCycleSpeed: masterCycleSpeed,
                scale: scale / child.radius, direction: direction * -1.0,
                compensation: naturalRotation * scale + compensation
            )
        }
    }

    func reify(scale: Double) {
        sprite.zRotation = rotation

        if suppressScaling {
            sprite.size = CGSize(width: radius * 2.0, height: radius * 2.0)
        } else {
            let reifiedRadius = scale
            sprite.size = CGSize(width: reifiedRadius * 2.0, height: reifiedRadius * 2.0)
        }

        for child in children.compactMap({ $0 as? Belle }) {
            var pp = CGPoint(x: child.position.r, y: 0)
            pp = pp.applying(CGAffineTransform(scaleX: scale, y: 0))
            pp = pp.applying(CGAffineTransform(rotationAngle: rotation))
            pp = pp.applying(CGAffineTransform(translationX: sprite.position.x, y: sprite.position.y))

            child.sprite.position = pp
            child.reify(scale: scale * child.radius)
        }
    }
}

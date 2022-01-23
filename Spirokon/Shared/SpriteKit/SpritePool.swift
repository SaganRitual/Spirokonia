import SpriteKit

class SpritePool {
    static let crosshairRingsLarge = SpritePool("Markers", "crosshair-ring-1024-4")
    static let crosshairRings2048x2048x24 = SpritePool("Markers", "crosshair-ring-2048x2048x24")
    static let dots = SpritePool("Markers", "circle-solid", cPreallocate: 100000)
    static let lines = SpritePool("Markers", "line-1024-10")
    static let plainRings = SpritePool("Markers", "ring-1024-4")
    static let spokeRingsLarge = SpritePool("Markers", "spoke-ring-1024-4")
    static let singleSpokeRingsLarge = SpritePool("Markers", "single-spoke-ring-1024-4")
    static let spokeRingsMedium = SpritePool("Markers", "spoke-ring-512-8")
    static let spokeRingsSmall = SpritePool("Markers", "spoke-ring-512-16")

    let atlas: SKTextureAtlas!
    var parkedDrones: [SKSpriteNode]
    let texture: SKTexture

    init(_ rect: CGRect, lineWidth: Double, scene: SKScene, cPreallocate: Int = 0) {
        var transform = CGAffineTransform(scaleX: scene.size.width, y: scene.size.height)

        let path = CGMutablePath(ellipseIn: rect, transform: &transform)

//        for t in 0..<3 {
//            path.move(to: CGPoint(radius: 0.25, theta: Double(t) * .tau / 3.0) + CGPoint(x: 1, y: 1), transform: transform)
//            path.addLine(to: CGPoint(radius: 0.75, theta: Double(t) * .tau / 3.0) + CGPoint(x: 1, y: 1), transform: transform)
//        }

        let shape = SKShapeNode(path: path)
        shape.lineWidth = lineWidth

        self.texture = scene.view!.texture(from: shape)!
        self.atlas = nil
        self.parkedDrones = []

        for _ in 0..<cPreallocate {
            parkedDrones.append(SKSpriteNode(texture: self.texture))
        }
    }

    init(_ atlasName: String, _ textureName: String, cPreallocate: Int = 0) {
        self.atlas = SKTextureAtlas(named: atlasName)
        self.texture = atlas.textureNamed(textureName)
        self.parkedDrones = []

        for _ in 0..<cPreallocate {
            parkedDrones.append(SKSpriteNode(texture: self.texture))
        }
    }

    func makeSprite() -> SKSpriteNode {
        let drone = getDrone()
        return makeSprite(with: drone)
    }

    func releaseSprite(_ sprite: SKSpriteNode, fullSKRemove: Bool = true) {
        if fullSKRemove {
            sprite.removeAllActions()
            sprite.removeFromParent()
        }

        parkedDrones.append(sprite)
    }
}

private extension SpritePool {

    func getDrone() -> SKSpriteNode {
        if parkedDrones.isEmpty {
            parkedDrones.append(SKSpriteNode(texture: self.texture))
        }

        return parkedDrones.popLast()!
    }

    func makeSprite(with drone: SKSpriteNode) -> SKSpriteNode {
        drone.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        drone.color = .white
        drone.colorBlendFactor = 1
        drone.zPosition = 1
        drone.zRotation = 0
        drone.alpha = 1
        drone.size = texture.size()
        return drone
    }
}

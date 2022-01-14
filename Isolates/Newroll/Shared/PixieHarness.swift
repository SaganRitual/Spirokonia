// We are a way for the cosmos to know itself. -- C. Sagan

import SpriteKit

class Pixie {
    let color: SKColor
    let sprite: SKSpriteNode

    init(radius: Double, color: SKColor, skParent: SKNode, pixoniaScene: PixoniaScene) {
        sprite = SpritePool.singleSpokeRingsLarge.makeSprite()
        sprite.color = color

        self.color = color
        skParent.addChild(sprite)
    }
}

final class DrawingPixie: Pixie {
    override init(radius: Double, color: SKColor, skParent: SKNode, pixoniaScene: PixoniaScene) {
        super.init(radius: radius, color: color, skParent: skParent, pixoniaScene: pixoniaScene)

        sprite.position = CGPoint(x: pixoniaScene.size.width / 2.0 * (1.0 - radius), y: 0)
    }
}

final class PlatterPixie: Pixie {
}

class PixieHarness {
    let pixoniaScene: PixoniaScene

    let pixieRadii: [Double] = [1.0 / 2.0, 1.0 / 3.0, 1.0 / 2.0, 1.0 / 3.0]
    let platterRadius = 1.0

    var colorSpeed = 0.1
    var currentDotColor = YAColor(hue: 0.0, saturation: 1.0, brightness: 1.0, alpha: 1.0)
    var cycleSpeed = 0.1

    var platter: Belle!
    var dotBelles = [Belle]()
    var drawingBelles = [DrawingBelle]()

    init(_ pixoniaScene: PixoniaScene) {
        self.pixoniaScene = pixoniaScene

        platter = Belle(pixoniaScene: pixoniaScene, spritePool: .singleSpokeRingsLarge)
        platter.radius = platterRadius
        platter.rollMode = .flattened
        platter.color = .blue

        var ucParent = platter!

        for ix in 0..<4 {
            let b = DrawingBelle(pixoniaScene: pixoniaScene, spritePool: .singleSpokeRingsLarge)
            b.radius = pixieRadii[ix]
            b.position.r = 1.0 - pixieRadii[ix]
            b.color = SKColor(AppDefinitions.drawingPixieColors[ix])

            let d = Belle(pixoniaScene: pixoniaScene, spritePool: .dots, suppressScaling: true)
            d.radius = 5
            d.position = UCPoint(r: 1.0, t: 0)
            d.color = YAColor(AppDefinitions.drawingPixieColors[ix]).rotateHue(byAngle: .pi)
            d.rollMode = .doesNotRoll

            b.addChild(d)

            ucParent.addChild(b)
            ucParent = b

            drawingBelles.append(b)
            dotBelles.append(d)
        }
    }

    func calculateDotColor(_ deltaTime: Double) {
        let colorRotation = colorSpeed * deltaTime * .tau
        currentDotColor = currentDotColor.rotateHue(byAngle: colorRotation)
    }

    func dropDot(at position: CGPoint) {
        let dot = SpritePool.dots.makeSprite()
        dot.size = CGSize(width: 5, height: 5)
        dot.position = position
        dot.color = currentDotColor

        pixoniaScene.addChild(dot)

        dot.run(SKAction.fadeOut(withDuration: 10), completion: { dot.removeFromParent() })
    }

    func update(_ deltaTime: Double) {
        calculateDotColor(deltaTime)

        platter.advance(by: deltaTime, masterCycleSpeed: cycleSpeed, scale: 1.0, direction: 1.0)
        platter.reify(scale: pixoniaScene.radius * platter.radius)

        dotBelles.enumerated().forEach { dropDot(at: $0.1.reifiedPosition) }
    }
}

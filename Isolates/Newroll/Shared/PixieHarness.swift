// We are a way for the cosmos to know itself. -- C. Sagan

import SpriteKit

class Pixie {
    let color: SKColor
    let sprite: SKSpriteNode

    init(radius: Double, color: SKColor, skParent: SKNode, pixoniaScene: PixoniaScene) {
        sprite = SpritePool.singleSpokeRingsLarge.makeSprite()
        sprite.size = pixoniaScene.size
        sprite.color = color
        sprite.setScale(radius)

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
    let drawingPixies: [DrawingPixie]
    let pixoniaScene: PixoniaScene
    let platterPixie: PlatterPixie

    let pixieRadii: [Double] = [1.0 / 2.0, 1.0 / 2.0, 1.0 / 2.0, 1.0 / 2.0]
    let platterRadius = 1.0

    var colorSpeed = 0.1
    var currentDotColor = YAColor(hue: 0.0, saturation: 1.0, brightness: 1.0, alpha: 1.0)
    var cycleSpeed = 0.1

    init(_ pixoniaScene: PixoniaScene) {
        self.pixoniaScene = pixoniaScene

        platterPixie = PlatterPixie(
            radius: platterRadius, color: .blue, skParent: pixoniaScene, pixoniaScene: pixoniaScene
        )

        var parent = platterPixie.sprite

        drawingPixies = (0..<4).map { [pixieRadii] ix in
            let newPixie = DrawingPixie(
                radius: pixieRadii[ix],
                color: SKColor(AppDefinitions.drawingPixieColors[ix]), skParent: parent,
                pixoniaScene: pixoniaScene
            )

            parent = newPixie.sprite
            return newPixie
        }
    }

    func calculateDotColor(_ deltaTime: Double) {
        let colorRotation = colorSpeed * deltaTime * .tau
        currentDotColor = currentDotColor.rotateHue(byAngle: colorRotation)
    }

    func dropDot(at position: CGPoint) {
        let dot = SpritePool.dots.makeSprite()
        dot.size = CGSize(width: 10, height: 10)
        dot.position = position
        dot.color = currentDotColor

        pixoniaScene.addChild(dot)

        dot.run(SKAction.fadeOut(withDuration: 10), completion: { dot.removeFromParent() })
    }

    func update(_ deltaTime: Double) {
        calculateDotColor(deltaTime)

        let rotation = deltaTime * cycleSpeed * .tau

        platterPixie.sprite.zRotation += rotation
        drawingPixies[0].sprite.zRotation += -1.0 * rotation / pixieRadii[0]
        drawingPixies[1].sprite.zRotation += +1.0 * rotation / (pixieRadii[0] * pixieRadii[1])
        drawingPixies[2].sprite.zRotation += -1.0 * rotation / (pixieRadii[0] * pixieRadii[1] * pixieRadii[2])
        drawingPixies[3].sprite.zRotation += +1.0 * rotation / (pixieRadii[0] * pixieRadii[1] * pixieRadii[2] * pixieRadii[3])

        let pp3 = CGPoint(x: pixoniaScene.size.width / 2.0, y: 0.0)
        let ppp3 = drawingPixies[3].sprite.convert(pp3, to: pixoniaScene)
        dropDot(at: ppp3)

        let pp2 = CGPoint(x: pixoniaScene.size.width / 2.0, y: 0.0)
        let ppp2 = drawingPixies[2].sprite.convert(pp2, to: pixoniaScene)
        dropDot(at: ppp2)

        let pp1 = CGPoint(x: pixoniaScene.size.width / 2.0, y: 0.0)
        let ppp1 = drawingPixies[1].sprite.convert(pp1, to: pixoniaScene)
        dropDot(at: ppp1)

        let pp0 = CGPoint(x: pixoniaScene.size.width / 2.0, y: 0.0)
        let ppp0 = drawingPixies[0].sprite.convert(pp0, to: pixoniaScene)
        dropDot(at: ppp0)
    }
}

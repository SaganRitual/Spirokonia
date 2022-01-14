// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import SpriteKit
import SwiftUI

struct DotSnapshot {
    let color: SKColor
    let dotPosition: CGPoint
    let dotZ: Double
    let trailDecay: Double
}

final class DrawingPixie: Pixie {
    let ix: Int
    var nextDotZ = 0.0
    var penPositionRAnimator: Animator<DrawingPixie>!
    var penPositionRObserver: AnyCancellable!
    let settingsModel: TumblerSettingsModel

    var currentDotColor = YAColor(hue: 0.0, saturation: 1.0, brightness: 1.0, alpha: 1.0)

    var hotPenPositionR = 1.0

    var connectorSprites = [SKSpriteNode]()

    init(
        ix: Int, radius: Double, color: SKColor, skParent: SKNode, pixoniaScene: PixoniaScene
    ) {
        self.ix = ix

        settingsModel = pixoniaScene.appModel.drawingTumblerSettingsModels.tumblerSettingsModels[ix]
        super.init(radius: radius, color: color, skParent: skParent, pixoniaScene: pixoniaScene)
    }

    func accumulatedScale() -> Double {
        var scale = pixoniaScene.pixieHarness.drawingPixies[self.ix].hotRadius

        for ix in (0..<self.ix).reversed() {
            scale *= pixoniaScene.pixieHarness.drawingPixies[ix].hotRadius
            if ix == self.ix { break }
        }

        return scale
    }

    override func advance(by rotation: Double) {
        sprite.position = CGPoint(x: pixoniaScene.size.width / 2.0 * (1.0 - hotRadius), y: 0)

        switch settingsModel.rollMode {
        case .normal:      sprite.zRotation += rotation
        case .compensate:  sprite.zRotation += 0.5 * rotation
        case .sticky:      break
        case .doesNotRoll: break
        }

        sprite.setScale(hotRadius)

        guard settingsModel.drawDots && settingsModel.penAxis > 0 else { return }

        let connectorIx = settingsModel.penAxis - 1
        let connectorSprite = connectorSprites[connectorIx]
        connectorSprite.position = sprite.convert(.zero, to: pixoniaScene)

        let connectedPixie = pixoniaScene.pixieHarness.drawingPixies[(ix + connectorIx + 1) % 4]
        let endPosition = connectedPixie.sprite.convert(.zero, to: pixoniaScene)
        connectorSprite.xScale = endPosition.distance(to: connectorSprite.position)

        let v = endPosition.vectorTo(otherPosition: connectorSprite.position)
        connectorSprite.zRotation = atan2(v.dy, v.dx)
    }

    func calculateDotColor(_ deltaTime: Double) {
        let colorRotation = settingsModel.colorSpeed * deltaTime * .tau
        currentDotColor = currentDotColor.rotateHue(byAngle: colorRotation)
    }

    override func postInit(_ appModel: AppModel) {
        penPositionRAnimator = Animator(\.hotPenPositionR, for: self)

        penPositionRObserver =
            appModel.drawingTumblerSettingsModels.tumblerSettingsModels[ix].$pen.sink {
                [weak self] newPenR in guard let myself = self else { return }
                myself.penPositionRAnimator.animate(to: newPenR)
            }

        radiusPublisher = appModel.drawingTumblerSettingsModels.tumblerSettingsModels[ix].$radius

        for _ in 0..<3 {
            let s = SpritePool.lines.makeSprite()
            s.color = self.ix == 0 ? .clear : .clear
            s.size.height = 10
            s.size.width = 1
            s.anchorPoint = .anchorDueWest
            pixoniaScene.addChild(s)
            connectorSprites.append(s)
        }

        super.postInit(appModel)
    }

    func takeSnapshot(deltaTime: Double, pixoniaScene: PixoniaScene) -> DotSnapshot {
        let p = CGPoint(x: hotPenPositionR * pixoniaScene.size.width / 2.0, y: 0.0)
        let pp = sprite.convert(p, to: pixoniaScene)

        calculateDotColor(deltaTime)

        let zOrder = Double(ix) + nextDotZ
        nextDotZ += 1e-4

        return DotSnapshot(
            color: currentDotColor, dotPosition: pp, dotZ: zOrder,
            trailDecay: settingsModel.trailDecay
        )
    }

    override func update(deltaTime: Double) {
        penPositionRAnimator.update(deltaTime: deltaTime / AppDefinitions.animationsDuration)

        sprite.color = settingsModel.showRing ? color : .clear

        super.update(deltaTime: deltaTime)
    }
}

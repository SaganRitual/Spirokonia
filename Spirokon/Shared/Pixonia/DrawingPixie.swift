// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import SpriteKit
import SwiftUI

final class DrawingPixie: Pixie {
    let ix: Int
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
        case .fullStop:    break
        case .doesNotRoll: break
        }

        sprite.setScale(hotRadius)

        guard settingsModel.drawDots && settingsModel.penAxis > 0 else { return }

        let connectorIx = settingsModel.penAxis - 1
        let connectorSprite = connectorSprites[connectorIx]
        connectorSprite.position = sprite.convert(.zero, to: pixoniaScene)

        let connectedPixie = pixoniaScene.pixieHarness.drawingPixies[(ix + connectorIx + 1) % 4]
        let endPosition = connectedPixie.sprite.convert(.zero, to: pixoniaScene)
        let e = endPosition.distance(to: connectorSprite.position)
        connectorSprite.xScale = 2.0 * e

        let v = endPosition.vectorTo(otherPosition: connectorSprite.position)
        connectorSprite.zRotation = atan2(v.dy, v.dx)
    }

    func calculateDotColor(_ deltaTime: Double) -> SKColor {
        let colorRotation = settingsModel.colorSpeed * deltaTime * .tau
        currentDotColor = currentDotColor.rotateHue(byAngle: colorRotation)
        return currentDotColor
    }

    func dropDot(deltaTime: Double, pixoniaScene: PixoniaScene) {
        let dot = SpritePool.dots.makeSprite()
        dot.size = CGSize(width: 10, height: 10)

        if settingsModel.penAxis == 0 {
            let p = CGPoint(x: hotPenPositionR * pixoniaScene.size.width / 2.0, y: 0.0)
            dot.position = sprite.convert(p, to: pixoniaScene)
        } else {
            let p = CGPoint(x: hotPenPositionR, y: 0.0)
            dot.position = connectorSprites[settingsModel.penAxis - 1].convert(p, to: pixoniaScene)
        }

        dot.color = calculateDotColor(deltaTime)

        pixoniaScene.addChild(dot)

        dot.run(SKAction.fadeOut(withDuration: 10), completion: { dot.removeFromParent() })
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
            s.color = self.ix == 0 ? .green : .clear
            s.size.height = 10
            s.size.width = 1
            s.anchorPoint = .anchorDueWest
            pixoniaScene.addChild(s)
            connectorSprites.append(s)
        }

        super.postInit(appModel)
    }

    override func update(deltaTime: Double) {
        penPositionRAnimator.update(deltaTime: deltaTime / AppDefinitions.animationsDuration)
        super.update(deltaTime: deltaTime)
    }
}

extension DrawingPixieHold {
    struct RSnapshot {
        let coreSnapshot: Supersprite.RSnapshot

        let color: SKColor
        let connector: PixieConnector
        let dotPosition: CGPoint
        let dotZ: Double
        let trailDecay: Double
    }
}

class DrawingPixieHold {
    let core: PixieCore

    let ix: Int
    var dotZ = 0.0

    var connectors = [PixieConnector]()
    var currentDotColor = YAColor(hue: 0.0, saturation: 1.0, brightness: 1.0, alpha: 1.0)
    var penPositionR = 0.0

    var penPositionRAnimator: Animator<DrawingPixieHold>!
    var penPositionRObserver: AnyCancellable!
    var settingsModel: TumblerSettingsModel!

    init(ix: Int, spritePool: SpritePool) {
        self.ix = ix

        self.core = .init(
            spritePool: spritePool, color: SKColor(AppDefinitions.drawingPixieColors[ix]),
            zIndex: 4 - ix, spaceName: "DrawingPixie(\(ix))"
        )
    }

    func nextDotZ() -> Double {
        dotZ += 1e-4
        if dotZ > Double(ix) + 2 { dotZ = 0 }
        return Double(ix) + dotZ
    }

    func postInit(
        connectTo pixies: [DrawingPixieHold], skParent: PixoniaScene, ucParent: UCSpace,
        appModel: AppModel
    ) {
        let rp = appModel.drawingTumblerSettingsModels.tumblerSettingsModels[ix].$radius
        core.postInit(skParent: skParent, ucParent: ucParent, radiusPublisher: rp)
        settingsModel = appModel.drawingTumblerSettingsModels.tumblerSettingsModels[ix]

        penPositionRAnimator = Animator(\.penPositionR, for: self)

        penPositionRObserver =
            appModel.drawingTumblerSettingsModels.tumblerSettingsModels[ix].$pen.sink {
                [weak self] newPenR in guard let myself = self else { return }
                myself.penPositionRAnimator.animate(to: newPenR)
            }

        connectors.append(PixieConnector(
            color: core.color, from: self, to: self, skParent: skParent, ucParent: ucParent
        ))

        connectors.append(contentsOf: pixies.map { otherPixie in
            PixieConnector(
                color: core.color, from: self, to: otherPixie,
                skParent: skParent, ucParent: ucParent
            )
        })
    }
}

extension DrawingPixieHold {
    func dropDot(_ snapshot: DrawingPixieHold.RSnapshot) {
        let dot = SpritePool.dots.makeSprite()
        dot.size = CGSize(width: 10, height: 10)

        dot.zPosition = snapshot.dotZ
        dot.position = snapshot.dotPosition
        dot.color = snapshot.color

        if dot.parent == nil { core.skParent.addChild(dot) }

        let fadeTime = 0.5
        assert(snapshot.trailDecay - fadeTime > 0)
        let delay = SKAction.wait(forDuration: snapshot.trailDecay - fadeTime)
        let fade = SKAction.fadeOut(withDuration: fadeTime)
        let sequence = SKAction.sequence([delay, fade])

        dot.run(sequence) { SpritePool.dots.releaseSprite(dot, fullSKRemove: false) }
    }
}

extension DrawingPixieHold {
    func calculateDotColor(_ deltaTime: Double) {
        let colorRotation = settingsModel.colorSpeed * deltaTime * .tau
        currentDotColor = currentDotColor.rotateHue(byAngle: colorRotation)
    }

    func showHidePen() {
        for (ix, connector) in connectors.enumerated() {
            guard ix == settingsModel.penAxis else {
                connector.nib.sprite.color = .clear
                connector.sprite.color = .clear
                continue
            }

            connector.nib.sprite.color =
                (settingsModel.drawDots || settingsModel.showRing) ? core.color : .clear

            connector.sprite.color = .clear

            connector.nib.space.position.r = penPositionR
            connector.nib.space.position.t = core.sprite.space.position.t
        }
    }
}

extension DrawingPixieHold {
    func makeSnapshot() -> RSnapshot {
        let nibPosition = connectors[settingsModel.penAxis].nib.sprite.position
        let dotPosition = connectors[settingsModel.penAxis].sprite.convert(nibPosition, to: core.skParent)

        return RSnapshot(
            coreSnapshot: core.sprite.makeSnapshot(),
            color: self.currentDotColor, connector: connectors[settingsModel.penAxis],
            dotPosition: dotPosition, dotZ: dotZ, trailDecay: settingsModel.trailDecay
        )
    }

    func update() {
        showHidePen()
        core.showRing(settingsModel.showRing)
    }
}

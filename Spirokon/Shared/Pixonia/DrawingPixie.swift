// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import SpriteKit
import SwiftUI

extension DrawingPixie {
    struct RSnapshot {
        let coreSnapshot: Supersprite.RSnapshot

        let color: SKColor
        let connector: PixieConnector
        let dotPosition: CGPoint
        let dotZ: Double
        let trailDecay: Double
    }
}

class DrawingPixie {
    let core: PixieCore

    let ix: Int
    var dotZ = 0.0

    var connectors = [PixieConnector]()
    var currentDotColor = YAColor(hue: 0.0, saturation: 1.0, brightness: 1.0, alpha: 1.0)
    var penAxis = 0
    var penPositionR = 0.0

    var penPositionRAnimator: Animator<DrawingPixie>!
    var penPositionRObserver: AnyCancellable!
    var settingsModel: TumblerSettingsModel!

    init(ix: Int, spritePool: SpritePool) {
        self.ix = ix

        self.core = .init(
            spritePool: spritePool, color: SKColor(AppDefinitions.drawingPixieColors[ix]), zIndex: 4 - ix
        )
    }

    func nextDotZ() -> Double {
        dotZ += 1e-4
        if dotZ > Double(ix) + 2 { dotZ = 0 }
        return Double(ix) + dotZ
    }

    func postInit(
        connectTo pixies: [DrawingPixie], skParent: PixoniaScene, ucParent: UCSpace,
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

extension DrawingPixie {
    func dropDot(_ snapshot: DrawingPixie.RSnapshot) {
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

extension DrawingPixie {
    func calculateDotColor(_ deltaTime: Double) {
        let colorRotation = settingsModel.colorSpeed * deltaTime * .tau
        currentDotColor = currentDotColor.rotateHue(byAngle: colorRotation)
    }

    func reify(to ancestorSpace: UCSpace) {
//        core.reify(to: ancestorSpace)
        connectors[penAxis].reify(to: ancestorSpace)
    }

    func showHidePen() {
        for (ix, connector) in connectors.enumerated() {
            guard ix == penAxis else {
                connector.nib.sprite.color = .clear
                connector.sprite.color = .clear
                continue
            }

            connector.nib.sprite.color =
                (settingsModel.drawDots || settingsModel.showRing) ? core.color : .clear

            connector.sprite.color = .clear

            connector.nib.space.position.r = penPositionR
        }
    }
}

extension DrawingPixie {
    func makeSnapshot() -> RSnapshot {
        let nibPosition = connectors[penAxis].nib.sprite.position
        let dotPosition = connectors[penAxis].sprite.convert(nibPosition, to: core.skParent)

        return RSnapshot(
            coreSnapshot: core.sprite.makeSnapshot(),
            color: self.currentDotColor, connector: connectors[penAxis],
            dotPosition: dotPosition, dotZ: dotZ, trailDecay: settingsModel.trailDecay
        )
    }

    func update() {
        showHidePen()
        core.showRing(settingsModel.showRing)
    }
}

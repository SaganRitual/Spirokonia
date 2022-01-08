// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import SpriteKit
import SwiftUI

class Pixie {
    let appModel: AppModel
    let ring: AppDefinitions.Ring
    let sprite: SKSpriteNode

    var space = UCSpace()
    var dotZ = 0.0

    var color = SKColor.red
    var currentDotColor = YAColor(hue: 0.0, saturation: 1.0, brightness: 1.0, alpha: 1.0)
    var firstPass = true

    var penAnimator: Animator<Pixie>?
    let radiusAnimator: Animator<UCSpace>

    var connectors = [PixieConnector]()

    var skParent: SKNode { sprite.parent! }
    var ucParent: UCSpace { space.parent! }

    var penAxis = 0
    var penR = 0.0

    var colorSpeed: Double {
        ring.ix == 0 ? 0 : settingsModel.colorSpeed
    }

    var drawDots: Bool {
        ring.ix == 0 ? false : settingsModel.drawDots
    }

    var rollMode: AppDefinitions.RollMode {
        ring.ix == 0 ? appModel.outerRingRollMode : settingsModel.rollMode
    }

    var showRing: Bool {
        ring.ix == 0 ? appModel.outerRingShow : settingsModel.showRing
    }

    var settingsModel: TumblerSettingsModel {
        assert(ring.ix != 0) // FIXME: Outer ring doesn't use the settings model; the whole structure is disgusting
        return appModel.drawingTumblerSettingsModels.tumblerSettingsModels[ring.ix - 1]
    }

    var trailDecay: Double {
        ring.ix == 0 ? 0 : settingsModel.trailDecay
    }

    var penAxisObserver: AnyCancellable!
    var penRObserver: AnyCancellable!
    var radiusObserver: AnyCancellable!

    init(
        _ ring: AppDefinitions.Ring, skParent: PixoniaScene, ucParent: UCSpace, appModel: AppModel
    ) {
        self.appModel = appModel
        self.ring = ring

        if ring.isInnerRing() {
            space.radius = 0.5
            penR = 1.0
        }

        switch ring {
        case .outerRing:
            sprite = SpritePool.crosshairRingsLarge.makeSprite()
            radiusAnimator = Animator(\.radius, for: self.space)

            penAnimator = nil

        case .innerRing(1):
            sprite = SpritePool.crosshairRingsLarge.makeSprite()
            radiusAnimator = Animator(\.radius, for: self.space)
            penAnimator = Animator(\.penR, for: self)

        case .innerRing(2), .innerRing(3):
            sprite = SpritePool.crosshairRingsLarge.makeSprite()
            radiusAnimator = Animator(\.radius, for: self.space)
            penAnimator = Animator(\.penR, for: self)

        case .innerRing(4):
            sprite = SpritePool.crosshairRingsLarge.makeSprite()
            radiusAnimator = Animator(\.radius, for: self.space)
            penAnimator = Animator(\.penR, for: self)

        default: fatalError()
        }

        sprite.zPosition = Double(-ring.ix)

        skParent.addChild(sprite)
        ucParent.addChild(space)
    }

    func advance(_ rotation: Double) {
        switch rollMode {
        case .normal:      space.rotation += rotation
        case .compensate:  space.rotation += rotation * 0.5
        case .fullStop:    break
        case .doesNotRoll: break
        }
    }

    func calculateColor(_ deltaTime: Double) {
        let colorRotation = colorSpeed * deltaTime * .tau
        currentDotColor = currentDotColor.rotateHue(byAngle: colorRotation)
    }

    func postInit(connectTo pixies: [Pixie]) {
        assert(ring.isInnerRing())

        penAxisObserver = appModel.drawingTumblerSettingsModels.tumblerSettingsModels[ring.ix - 1].$penAxis.sink {
            [weak self] newPenAxis in guard let myself = self else { return }
            myself.penAxis = newPenAxis
        }

        penRObserver = appModel.drawingTumblerSettingsModels.tumblerSettingsModels[ring.ix - 1].$pen.sink {
            [weak self] newPenR in guard let myself = self else { return }
            myself.penAnimator!.animate(to: newPenR)
        }

        radiusObserver = appModel.drawingTumblerSettingsModels.tumblerSettingsModels[ring.ix - 1].$radius.sink {
            [weak self] newRadius in guard let myself = self else { return }
            myself.radiusAnimator.animate(to: newRadius)
        }

        connectors.append(PixieConnector(
            color: color, from: self, to: self, skParent: sprite.scene!, ucParent: space
        ))

        connectors.append(contentsOf: pixies.map { otherPixie in
            PixieConnector(
                color: color, from: self, to: otherPixie, skParent: sprite.scene!, ucParent: space
            )
        })
    }

    func reify(to ancestorSpace: UCSpace) {
        sprite.position = ancestorSpace.emplace(space).cgPoint
        sprite.size = ancestorSpace.ensize(space).cgSize
        sprite.zRotation = space.rotation

        if !connectors.isEmpty {
            connectors[penAxis].reify(to: ancestorSpace)
        }
    }

    func showHidePen() {
        for (ix, connector) in connectors.enumerated() {
            guard ix == penAxis else {
                connector.nib.sprite.color = .clear
                connector.sprite.color = .clear
                continue
            }

            connector.nib.sprite.color = (ring.ix > 0 && (drawDots || showRing)) ? color : .clear
            connector.sprite.color = (ring.ix > 0 && (drawDots || showRing)) ? color : .clear
        }
    }

    func showHideRing() {
        sprite.color = showRing ? color : .clear
    }
}

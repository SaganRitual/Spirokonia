// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation

struct PixieHarnessSnapshot {
    let platterSnapshot: Supersprite.RSnapshot
    let drawingSnapshots: [DrawingPixie.RSnapshot]
}

class PixieHarness {
    let appModel: AppModel
    let drawingPixies: [DrawingPixie]
    let platterPixie: PlatterPixie
    let space: UCSpace

    init(pixoniaScene: PixoniaScene, appModel: AppModel) {
        self.appModel = appModel

        space = UCSpace(radius: pixoniaScene.size.width / 2.0)

        drawingPixies = (0..<4).map {
            DrawingPixie(ix: $0, spritePool: .crosshairRingsLarge)
        }

        platterPixie = PlatterPixie(spritePool: .crosshairRingsLarge, appModel: appModel)

        var ucParent: UCSpace = platterPixie.core.sprite.space

        drawingPixies.forEach { pixie in
            let connect = (1..<4).map { ss in drawingPixies[(pixie.ix + ss) % 4] }

            pixie.postInit(
                connectTo: connect, skParent: pixoniaScene, ucParent: ucParent, appModel: appModel
            )

            ucParent = pixie.core.sprite.space
        }

        platterPixie.postInit(skParent: pixoniaScene, ucParent: space, appModel: appModel)
    }
}

extension PixieHarness {
    func advance(by deltaTime: Double) {
        var direction = -1.0
        var rotation = appModel.cycleSpeed * deltaTime * .tau

        spin(
            space: platterPixie.core.sprite.space, by: rotation,
            rollMode: appModel.outerRingRollMode
        )

        platterPixie.core.sprite.reify(to: space)

        drawingPixies.forEach { pixie in
            pixie.calculateDotColor(deltaTime)
            pixie.core.sprite.space.position.r = 1.0 - pixie.core.sprite.space.radius

            spin(space: pixie.core.sprite.space, by: rotation, rollMode: pixie.settingsModel.rollMode)

            pixie.core.sprite.reify(to: space)
            pixie.connectors.forEach { $0.reify(to: space) }

            rotation /= pixie.core.sprite.space.radius
            direction *= -1.0
        }
    }

    func makeSnapshot() -> PixieHarnessSnapshot {
        PixieHarnessSnapshot(
            platterSnapshot: platterPixie.core.sprite.makeSnapshot(),
            drawingSnapshots: drawingPixies.map { $0.makeSnapshot() }
        )
    }
}

private extension PixieHarness {
    func spin(space: UCSpace, by rotation: Double, rollMode: AppDefinitions.RollMode) {
        switch rollMode {
        case .normal:      space.rotation += rotation
        case .compensate:  space.rotation += rotation * 0.5
        case .fullStop:    break
        case .doesNotRoll: break
        }
    }
}

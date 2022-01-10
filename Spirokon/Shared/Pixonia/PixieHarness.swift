// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import SpriteKit

class PixieHarness {
    let appModel: AppModel
    let drawingPixies: [DrawingPixie]
    let pixoniaScene: PixoniaScene
    let platterPixie: PlatterPixie

    init(pixoniaScene: PixoniaScene, appModel: AppModel) {
        self.appModel = appModel
        self.pixoniaScene = pixoniaScene

        platterPixie = PlatterPixie(
            radius: appModel.outerRingRadius, color: SKColor(AppDefinitions.platterPixieColor),
            skParent: pixoniaScene, pixoniaScene: pixoniaScene
        )

        platterPixie.postInit(appModel)

        var parent = platterPixie.sprite

        drawingPixies = (0..<4).map { ix in
            let newPixie = DrawingPixie(
                ix: ix,
                radius: appModel.drawingTumblerSettingsModels.tumblerSettingsModels[ix].radius,
                color: SKColor(AppDefinitions.drawingPixieColors[ix]), skParent: parent,
                pixoniaScene: pixoniaScene
            )

            newPixie.postInit(appModel)

            parent = newPixie.sprite
            return newPixie
        }
    }
}

extension PixieHarness {
    func advance(by deltaTime: Double) {
        var direction = 1.0
        var rotation = deltaTime * appModel.cycleSpeed * .tau

        platterPixie.advance(by: direction * rotation)

        for pixie in drawingPixies {
            direction *= -1.0
            rotation /= pixie.hotRadius

            pixie.advance(by: direction * rotation, deltaTime: deltaTime)
        }
    }

    func update(_ deltaTime: Double) {
        platterPixie.update(deltaTime: deltaTime)
        drawingPixies.forEach { $0.update(deltaTime: deltaTime) }
    }
}

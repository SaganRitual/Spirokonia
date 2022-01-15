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

final class DrawingBelle: Belle {
    let dotBelle: Belle
    let ix: Int
    var nextDotZ = 0.0
    var penPositionRAnimator: Animator<UCSpace>!
    var penPositionRObserver: AnyCancellable!
    let settingsModel: TumblerSettingsModel

    var currentDotColor = YAColor(hue: 0.0, saturation: 1.0, brightness: 1.0, alpha: 1.0)

    init(
        ix: Int, radius: Double, color: SKColor, skParent: SKNode, pixoniaScene: PixoniaScene
    ) {
        self.ix = ix

        settingsModel = pixoniaScene.appModel.drawingTumblerSettingsModels.tumblerSettingsModels[ix]

        dotBelle = Belle(
            pixoniaScene: pixoniaScene, spritePool: .dots,
            color: color, suppressScaling: true
        )

        dotBelle.radius = 7
        dotBelle.rollMode = .doesNotRoll

        super.init(pixoniaScene: pixoniaScene, spritePool: .spokeRingsLarge, color: color)

        self.addChild(dotBelle)
    }

    func calculateDotColor(_ deltaTime: Double) {
        let colorRotation = settingsModel.colorSpeed * deltaTime * .tau
        currentDotColor = currentDotColor.rotateHue(byAngle: colorRotation)
    }

    override func postInit(_ appModel: AppModel) {
        penPositionRAnimator = Animator(\.position.r, for: dotBelle)

        penPositionRObserver =
            appModel.drawingTumblerSettingsModels.tumblerSettingsModels[ix].$pen.sink {
                [weak self] newPenR in guard let myself = self else { return }
                myself.penPositionRAnimator.animate(to: newPenR)
            }

        radiusPublisher = appModel.drawingTumblerSettingsModels.tumblerSettingsModels[ix].$radius

        super.postInit(appModel)
    }

    override func showHide(_ show: Bool) {
        dotBelle.showHide(show && settingsModel.drawDots)
        super.showHide(show)
    }

    func takeSnapshot(deltaTime: Double, pixoniaScene: PixoniaScene) -> DotSnapshot {
        calculateDotColor(deltaTime)

        let zOrder = Double(ix) + nextDotZ
        nextDotZ += 1e-4

        return DotSnapshot(
            color: currentDotColor, dotPosition: dotBelle.reifiedPosition, dotZ: zOrder,
            trailDecay: settingsModel.trailDecay
        )
    }

    override func update(deltaTime: Double) {
        penPositionRAnimator.update(deltaTime: deltaTime / AppDefinitions.animationsDuration)
        showHide(settingsModel.showRing)
        super.update(deltaTime: deltaTime)
    }
}

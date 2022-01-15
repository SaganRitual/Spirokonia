// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import SpriteKit
import SwiftUI

final class PlatterBelle: Belle {
    override func advance(
        by deltaTime: Double, masterCycleSpeed: Double, scale: Double, direction: Double,
        compensation: Double = 0.0
    ) {
        super.advance(
            by: deltaTime, masterCycleSpeed: masterCycleSpeed, scale: scale,
            direction: direction, rollMode: pixoniaScene.appModel.outerRingRollMode,
            compensation: compensation
        )
    }

    override func postInit(_ appModel: AppModel) {
        radiusPublisher = appModel.$outerRingRadius
        super.postInit(appModel)
    }

    override func update(deltaTime: Double) {
        showHide(pixoniaScene.appModel.outerRingShow)
        super.update(deltaTime: deltaTime)
    }
}

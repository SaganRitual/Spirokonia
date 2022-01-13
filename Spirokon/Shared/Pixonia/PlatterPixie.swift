// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import SpriteKit
import SwiftUI

final class PlatterPixie: Pixie {
    override func advance(by rotation: Double) {
        if pixoniaScene.appModel.outerRingRollMode == .normal {
            sprite.zRotation += rotation
        }

        sprite.setScale(hotRadius)
    }

    override func postInit(_ appModel: AppModel) {
        radiusPublisher = appModel.$outerRingRadius
        super.postInit(appModel)
    }

    override func update(deltaTime: Double) {
        sprite.color = pixoniaScene.appModel.outerRingShow ? color : .clear
        super.update(deltaTime: deltaTime)
    }
}

class PlatterPixieHold {
    let core: PixieCore

    init(spritePool: SpritePool, appModel: AppModel) {
        self.core = .init(
            spritePool: spritePool, color: SKColor(AppDefinitions.platterPixieColor), zIndex: 0,
            spaceName: "PlatterPixie"
        )
    }

    func postInit(skParent: PixoniaScene, ucParent: UCSpace, appModel: AppModel) {
        core.postInit(
            skParent: skParent, ucParent: ucParent, radiusPublisher: appModel.$outerRingRadius
        )
    }
}

extension PlatterPixieHold {
    func update(appModel: AppModel) { core.showRing(appModel.outerRingShow) }
}

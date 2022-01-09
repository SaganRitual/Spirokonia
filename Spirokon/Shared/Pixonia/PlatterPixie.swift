// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import SpriteKit
import SwiftUI

class PlatterPixie {
    let core: PixieCore

    init(spritePool: SpritePool, appModel: AppModel) {
        self.core = .init(
            spritePool: spritePool, color: SKColor(AppDefinitions.platterPixieColor), zIndex: 0
        )
    }

    func postInit(skParent: PixoniaScene, ucParent: UCSpace, appModel: AppModel) {
        core.postInit(
            skParent: skParent, ucParent: ucParent, radiusPublisher: appModel.$outerRingRadius
        )
    }
}

extension PlatterPixie {
    func update(appModel: AppModel) { core.showRing(appModel.outerRingShow) }
}

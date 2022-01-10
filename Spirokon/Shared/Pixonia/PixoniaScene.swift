// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import SpriteKit
import SwiftUI

class PixoniaScene: SKScene, SKSceneDelegate, ObservableObject {
    @ObservedObject var appModel: AppModel
    @ObservedObject var tumblerSelectorStateMachine: TumblerSelectorStateMachine

    let dotsQueue = DispatchQueue(
        label: "scene.pixonia", attributes: [/*serial*/], target: DispatchQueue.main
    )

    let radius: Double = 2048

    var pixieHarness: PixieHarness!
    var previousTime: TimeInterval?

    init(appModel: AppModel, tumblerSelectorStateMachine: TumblerSelectorStateMachine) {
        _appModel = ObservedObject(initialValue: appModel)
        _tumblerSelectorStateMachine = ObservedObject(initialValue: tumblerSelectorStateMachine)

        super.init(size: CGSize(width: radius * 2, height: radius * 2))

        pixieHarness = PixieHarness(pixoniaScene: self, appModel: appModel)

        self.anchorPoint = .anchorAtCenter
        self.scaleMode = .aspectFit
        self.backgroundColor = .black
    }

    override func update(_ currentTime: TimeInterval) {
        let deltaTime = 1.0 / 60.0

        pixieHarness.update(deltaTime)

        // We'll do this in the dense update, when the time comes
        pixieHarness.advance(by: deltaTime)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

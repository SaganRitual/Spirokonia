// We are a way for the cosmos to know itself. -- C. Sagan

import SpriteKit
import SwiftUI

class PixoniaScene: SKScene, SKSceneDelegate, ObservableObject {
    @ObservedObject var appState: AppState

    let mainControl = MainControl()
    let outerRing = OuterRing()
    let innerRings: [InnerRing]

    init(appState: ObservedObject<AppState>) {
        self._appState = appState

        self.innerRings = (1..<5).map { InnerRing(.innerRing($0)) }

        super.init(size: CGSize(width: 1024, height: 1024))

        self.anchorPoint = .anchorAtCenter
        self.scaleMode = .aspectFit
        self.backgroundColor = .black

        self.addChild(mainControl.pixieProxy.skNode)
        self.addChild(outerRing.pixieProxy.skNode)
        self.innerRings.forEach { [weak self] in self?.addChild($0.pixieProxy.skNode) }
    }

    override func update(_ currentTime: TimeInterval) {
        mainControl.pixieProxy.labels[0].update("\(appState.cycleSpeed.as3())")
        mainControl.pixieProxy.labels[1].update("\(appState.density.asString(decimals: 0))")

        outerRing.pixieProxy.labels[0].update("\(appState.outerRingRollMode)")
        outerRing.pixieProxy.labels[1].update("\(appState.outerRingShow)")
        outerRing.pixieProxy.labels[2].update("\(appState.outerRingRadius.as3())")

        for r_ in 1..<5 {
            let r = r_ - 1
            innerRings[r].pixieProxy.labels[0].update("\(appState.innerRingRollMode)")
            innerRings[r].pixieProxy.labels[1].update("\(appState.innerRingShow)")
            innerRings[r].pixieProxy.labels[2].update("\(appState.drawDots)")
            innerRings[r].pixieProxy.labels[3].update("\(appState.radius.as3())")
            innerRings[r].pixieProxy.labels[4].update("\(appState.pen.as3())")
            innerRings[r].pixieProxy.labels[5].update("\(appState.colorSpeed.as3())")
            innerRings[r].pixieProxy.labels[6].update("\(appState.trailDecay.as3())")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

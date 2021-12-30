// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import SpriteKit
import SwiftUI

class PixoniaScene: SKScene, SKSceneDelegate, ObservableObject {
    @ObservedObject var appState: AppState

    var pixie: Pixie!
    var previousTime: Double?
    var radiusObserver: AnyCancellable!
    let ucWorld: UCWorld

    let side: Double = 1024

    init(appState: ObservedObject<AppState>) {
        self._appState = appState

        ucWorld = UCWorld(width: side, height: side)
        super.init(size: ucWorld.size.cgSize)

        self.anchorPoint = .anchorAtCenter
        self.scaleMode = .aspectFit
        self.backgroundColor = .black
    }

    override func didMove(to view: SKView) {
        pixie = Pixie(.outerRing, skParent: self, ucParent: ucWorld.theWorldSpace)

        // Capture the value of startScale at the time of the notification, not the
        // value it had when the user started dragging
        radiusObserver = appState.$radius.sink { [weak self] newRadius in
            self?.pixie.radiusAnimator.animate(to: newRadius)
       }
    }

    override func update(_ currentTime: TimeInterval) {
        pixie.applyUIStateToPixieStateIf(appState)
        pixie.reify(ucWorld: ucWorld)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

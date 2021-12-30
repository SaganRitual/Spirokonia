// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import SpriteKit
import SwiftUI

class PixoniaScene: SKScene, SKSceneDelegate, ObservableObject {
    @ObservedObject var appState: AppState
    @ObservedObject var tumblerSelectorStateMachine: TumblerSelectorStateMachine

    var pixieProxies = [HasTumblerSettings]()

    var selectionObserver: AnyCancellable!

    init(
        appState: ObservedObject<AppState>,
        tumblerSelectorStateMachine: ObservedObject<TumblerSelectorStateMachine>
    ) {
        self._appState = appState
        self._tumblerSelectorStateMachine = tumblerSelectorStateMachine

        super.init(size: CGSize(width: 1024, height: 1024))

        self.anchorPoint = .anchorAtCenter
        self.scaleMode = .aspectFit
        self.backgroundColor = .black
    }

    override func didMove(to view: SKView) {
        selectionObserver = tumblerSelectorStateMachine.$indexOfDrivingTumbler.sink {
            [weak self] in
            guard let _ = self else { return }
            guard let newDriverIx = $0 else {
                print("clear ui")
                return
            }

            print("charge ui with \(newDriverIx)")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

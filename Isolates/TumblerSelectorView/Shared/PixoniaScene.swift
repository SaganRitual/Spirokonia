// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import SpriteKit
import SwiftUI

class PixoniaScene: SKScene, SKSceneDelegate, ObservableObject {
    @ObservedObject var appState: AppState
    @ObservedObject var tumblerSelectorStateMachine: TumblerSelectorStateMachine

    let mainControl = MainControl()
    let outerRing = OuterRing()
    let innerRings: [InnerRing]

    var colorSpeedObserver: AnyCancellable!
    var drawDotsObserver: AnyCancellable!
    var penObserver: AnyCancellable!
    var radiusObserver: AnyCancellable!
    var rollModeObserver: AnyCancellable!
    var selectionStateObserver: AnyCancellable!
    var showRingObserver: AnyCancellable!
    var trailDecayObserver: AnyCancellable!

    var isReady = false

    init(
        appState: ObservedObject<AppState>,
        tumblerSelectorStateMachine: ObservedObject<TumblerSelectorStateMachine>
    ) {
        self._appState = appState
        self._tumblerSelectorStateMachine = tumblerSelectorStateMachine

        self.innerRings = (1...4).map { InnerRing(.innerRing($0)) }

        super.init(size: CGSize(width: 1024, height: 1024))

        self.anchorPoint = .anchorAtCenter
        self.scaleMode = .aspectFit
        self.backgroundColor = .black

        self.addChild(mainControl.pixieProxy.skNode)
        self.addChild(outerRing.pixieProxy.skNode)
        self.innerRings.forEach { [weak self] in self?.addChild($0.pixieProxy.skNode) }
    }

    override func didMove(to view: SKView) {
        setupSettingsObservers()

        selectionStateObserver = tumblerSelectorStateMachine.$indexOfDrivingTumbler.sink {
            [weak self] in guard let pixoniaScene = self else { return }

            // We don't want to do anything until all the observers are in place and have
            // receieved their initial notification. So we set up this observer--the one for
            // the selection state--last, and here we're telling our update function that
            // we're finally ready for business.
            pixoniaScene.isReady = true

            guard let driver = $0 else { return }
            pixoniaScene.innerRings[driver].pixieProxy.tumblerSettings.copy(to: pixoniaScene.appState)
        }
    }

    func setupSettingsObservers() {
        colorSpeedObserver = appState.$colorSpeed.sink { [weak self] colorSpeed in
            guard let pixoniaScene = self else { return }

            for (ix, `switch`) in pixoniaScene.appState.tumblerSelectorSwitches.enumerated() where `switch`.isTracking {
                pixoniaScene.innerRings[ix].pixieProxy.tumblerSettings.colorSpeed = colorSpeed
            }
        }

        drawDotsObserver = appState.$drawDots.sink { [weak self] drawDots in
            guard let pixoniaScene = self else { return }

            for (ix, `switch`) in pixoniaScene.appState.tumblerSelectorSwitches.enumerated() where `switch`.isTracking {
                pixoniaScene.innerRings[ix].pixieProxy.tumblerSettings.drawDots = drawDots
            }
        }

        penObserver = appState.$pen.sink { [weak self] pen in
            guard let pixoniaScene = self else { return }

            for (ix, `switch`) in pixoniaScene.appState.tumblerSelectorSwitches.enumerated() where `switch`.isTracking {
                pixoniaScene.innerRings[ix].pixieProxy.tumblerSettings.pen = pen
            }
        }

        radiusObserver = appState.$radius.sink { [weak self] radius in
            guard let pixoniaScene = self else { return }

            for (ix, `switch`) in pixoniaScene.appState.tumblerSelectorSwitches.enumerated() where `switch`.isTracking {
                pixoniaScene.innerRings[ix].pixieProxy.tumblerSettings.radius = radius
            }
        }

        rollModeObserver = appState.$innerRingRollMode.sink { [weak self] rollMode in
            guard let pixoniaScene = self else { return }

            for (ix, `switch`) in pixoniaScene.appState.tumblerSelectorSwitches.enumerated() where `switch`.isTracking {
                pixoniaScene.innerRings[ix].pixieProxy.tumblerSettings.rollMode = rollMode
            }
        }

        showRingObserver = appState.$innerRingShow.sink { [weak self] showRing in
            guard let pixoniaScene = self else { return }

            for (ix, `switch`) in pixoniaScene.appState.tumblerSelectorSwitches.enumerated() where `switch`.isTracking {
                pixoniaScene.innerRings[ix].pixieProxy.tumblerSettings.showRing = showRing
            }
        }

        trailDecayObserver = appState.$trailDecay.sink { [weak self] trailDecay in
            guard let pixoniaScene = self else { return }

            for (ix, `switch`) in pixoniaScene.appState.tumblerSelectorSwitches.enumerated() where `switch`.isTracking {
                pixoniaScene.innerRings[ix].pixieProxy.tumblerSettings.trailDecay = trailDecay
            }
        }
    }

    override func update(_ currentTime: TimeInterval) {
        mainControl.pixieProxy.labels[0].update("\(appState.cycleSpeed.as3())")
        mainControl.pixieProxy.labels[1].update("\(appState.density.asString(decimals: 0))")

        outerRing.pixieProxy.labels[0].update("\(appState.outerRingRollMode)")
        outerRing.pixieProxy.labels[1].update("\(appState.outerRingShow)")
        outerRing.pixieProxy.labels[2].update("\(appState.outerRingRadius.as3())")

        innerRings.forEach { $0.pixieProxy.update() }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

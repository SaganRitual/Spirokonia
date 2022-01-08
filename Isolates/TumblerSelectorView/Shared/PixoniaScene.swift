// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import SpriteKit
import SwiftUI

class PixoniaScene: SKScene, SKSceneDelegate, ObservableObject {
    @ObservedObject var appModel: AppModel
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
        appModel: ObservedObject<AppModel>,
        tumblerSelectorStateMachine: ObservedObject<TumblerSelectorStateMachine>
    ) {
        self._appState = appModel
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
            pixoniaScene.innerRings[driver].pixieProxy.tumblerSettings.copy(to: pixoniaScene.appModel)
        }
    }

    func setupSettingsObservers() {
        colorSpeedObserver = appModel.$colorSpeed.sink { [weak self] colorSpeed in
            guard let pixoniaScene = self else { return }

            for (ix, theSwitch) in pixoniaScene.appModel.tumblerSelectorSwitches.enumerated() where theSwitch.isTracking {
                pixoniaScene.innerRings[ix].pixieProxy.tumblerSettings.colorSpeed = colorSpeed
            }
        }

        drawDotsObserver = appModel.$drawDots.sink { [weak self] drawDots in
            guard let pixoniaScene = self else { return }

            for (ix, theSwitch) in pixoniaScene.appModel.tumblerSelectorSwitches.enumerated() where theSwitch.isTracking {
                pixoniaScene.innerRings[ix].pixieProxy.tumblerSettings.drawDots = drawDots
            }
        }

        penObserver = appModel.$pen.sink { [weak self] pen in
            guard let pixoniaScene = self else { return }

            for (ix, theSwitch) in pixoniaScene.appModel.tumblerSelectorSwitches.enumerated() where theSwitch.isTracking {
                pixoniaScene.innerRings[ix].pixieProxy.tumblerSettings.pen = pen
            }
        }

        radiusObserver = appModel.$radius.sink { [weak self] radius in
            guard let pixoniaScene = self else { return }

            for (ix, theSwitch) in pixoniaScene.appModel.tumblerSelectorSwitches.enumerated() where theSwitch.isTracking {
                pixoniaScene.innerRings[ix].pixieProxy.tumblerSettings.radius = radius
            }
        }

        rollModeObserver = appModel.$innerRingRollMode.sink { [weak self] rollMode in
            guard let pixoniaScene = self else { return }

            for (ix, theSwitch) in pixoniaScene.appModel.tumblerSelectorSwitches.enumerated() where theSwitch.isTracking {
                pixoniaScene.innerRings[ix].pixieProxy.tumblerSettings.rollMode = rollMode
            }
        }

        showRingObserver = appModel.$innerRingShow.sink { [weak self] showRing in
            guard let pixoniaScene = self else { return }

            for (ix, theSwitch) in pixoniaScene.appModel.tumblerSelectorSwitches.enumerated() where theSwitch.isTracking {
                pixoniaScene.innerRings[ix].pixieProxy.tumblerSettings.showRing = showRing
            }
        }

        trailDecayObserver = appModel.$trailDecay.sink { [weak self] trailDecay in
            guard let pixoniaScene = self else { return }

            for (ix, theSwitch) in pixoniaScene.appModel.tumblerSelectorSwitches.enumerated() where theSwitch.isTracking {
                pixoniaScene.innerRings[ix].pixieProxy.tumblerSettings.trailDecay = trailDecay
            }
        }
    }

    override func update(_ currentTime: TimeInterval) {
        mainControl.pixieProxy.labels[0].update("\(appModel.cycleSpeed.as3())")
        mainControl.pixieProxy.labels[1].update("\(appModel.density.asString(decimals: 0))")

        outerRing.pixieProxy.labels[0].update("\(appModel.outerRingRollMode)")
        outerRing.pixieProxy.labels[1].update("\(appModel.outerRingShow)")
        outerRing.pixieProxy.labels[2].update("\(appModel.outerRingRadius.as3())")

        innerRings.forEach { $0.pixieProxy.update() }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

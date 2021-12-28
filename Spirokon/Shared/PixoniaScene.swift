// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import SpriteKit
import SwiftUI

class PixoniaScene: SKScene, SKSceneDelegate, ObservableObject {
    @ObservedObject var appState: AppState

    var isReady = false

    var masterPixieForSelectorSwitches: Int?
    var previousTime: TimeInterval?
    var pixies = [Pixie]()

    var colorSpeedObserver: AnyCancellable!
    var densityObserver: AnyCancellable!
    var drawDotsObserver: AnyCancellable!
    var penObserver: AnyCancellable!
    var radiusObserver: AnyCancellable!
    var rollModeObserver: AnyCancellable!
    var showRingObserver: AnyCancellable!
    var trailDecayObserver: AnyCancellable!

    init(appState: ObservedObject<AppState>) {
        _appState = appState

        super.init(size: CGSize(width: 1024, height: 1024))

        self.anchorPoint = .anchorAtCenter
        self.scaleMode = .aspectFill
        self.backgroundColor = .black
    }

    override func didMove(to view: SKView) {
        for p in 0..<5 {
            let ring: AppState.Ring
            let parent: SKNode

            if p == 0 {
                ring = .outerRing
                parent = self
            } else {
                ring = .innerRing(p)
                parent = pixies.last!.sprite
            }

            let pixie = Pixie(ring, parent: parent)
            pixie.postInit(appState: _appState)

            pixie.sprite.size = self.size
            pixie.sprite.setScale(pixie.radius)

            pixie.color = SKColor([Color.orange, Color.green, Color.blue, Color.yellow, Color.red][p])

            pixies.append(pixie)
        }

        setupObservers()
    }

    func setupObservers() {
        colorSpeedObserver = appState.$colorSpeed.sink { [weak self] colorSpeed in
            guard let myself = self else { return }

            for (ix, `switch`) in myself.appState.tumblerSelectorSwitches.enumerated() where `switch`.isTracking {
                myself.pixies[ix + 1].colorSpeed = colorSpeed
            }
        }

        densityObserver = appState.$density.sink { [weak self] density in
            guard let myself = self else { return }

            for (ix, `switch`) in myself.appState.tumblerSelectorSwitches.enumerated() where `switch`.isTracking {
                myself.pixies[ix + 1].density = density
            }
        }

        drawDotsObserver = appState.$drawDotsInner.sink { [weak self] drawDots in
            guard let myself = self else { return }

            for (ix, `switch`) in myself.appState.tumblerSelectorSwitches.enumerated() where `switch`.isTracking {
                myself.pixies[ix + 1].drawDots = drawDots
            }
        }

        penObserver = appState.$pen.sink { [weak self] pen in
            guard let myself = self else { return }

            for (ix, `switch`) in myself.appState.tumblerSelectorSwitches.enumerated() where `switch`.isTracking {
                myself.pixies[ix + 1].pen = pen
            }
        }

        radiusObserver = appState.$radius.sink { [weak self] radius in
            guard let myself = self else { return }

            for (ix, `switch`) in myself.appState.tumblerSelectorSwitches.enumerated() where `switch`.isTracking {
                myself.pixies[ix + 1].radius = radius
            }
        }

        rollModeObserver = appState.$innerRingRollMode.sink { [weak self] rollMode in
            guard let myself = self else { return }

            for (ix, `switch`) in myself.appState.tumblerSelectorSwitches.enumerated() where `switch`.isTracking {
                myself.pixies[ix + 1].rollMode = rollMode
            }
        }

        showRingObserver = appState.$showRingInner.sink { [weak self] showRing in
            guard let myself = self else { return }

            for (ix, `switch`) in myself.appState.tumblerSelectorSwitches.enumerated() where `switch`.isTracking {
                myself.pixies[ix + 1].showRing = showRing
            }
        }

        trailDecayObserver = appState.$trailDecay.sink { [weak self] trailDecay in
            guard let myself = self else { return }

            for (ix, `switch`) in myself.appState.tumblerSelectorSwitches.enumerated() where `switch`.isTracking {
                myself.pixies[ix + 1].trailDecay = trailDecay
            }

            myself.isReady = true
        }
    }

    override func update(_ currentTime: TimeInterval) {
        defer { previousTime = currentTime }
        guard let previousTime = previousTime, isReady else { return }
        let deltaTime_ = currentTime - previousTime
        let deltaTime = min(deltaTime_, 1.0 / 60.0)

        var direction = -1.0
        var totalScale = 1.0

        for pixie in pixies {
            pixie.applyUIStateToPixieStateIf(appState)
            pixie.applyPixieStateToSprite()

            pixie.sprite.position = pixie.isOuterRing ? .zero :
                CGPoint(x: (self.size.width - pixie.sprite.size.width) / 2, y: 0)

            direction *= -1

            // Don't scale the rotation for the outer ring's radius; the rotation rate
            // is always the same no matter its size
            if case AppState.Ring.innerRing = pixie.ring { totalScale *= pixie.radius }

            pixie.roll(2.0 * direction * appState.cycleSpeed * deltaTime * .tau / totalScale)

            pixie.dropDot(onto: self, deltaTime: deltaTime)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

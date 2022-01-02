// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import SpriteKit
import SwiftUI

class PixoniaScene: SKScene, SKSceneDelegate, ObservableObject {
    @ObservedObject var appState: AppState
    @ObservedObject var tumblerSelectorStateMachine: TumblerSelectorStateMachine

    let dotsQueue = DispatchQueue(
        label: "scene.pixonia", attributes: .concurrent, target: DispatchQueue.global()
    )

    var isReady = false

    var masterPixieForSelectorSwitches: Int?
    var previousTime: TimeInterval?
    var pixies = [Pixie]()
    var liveShadowPixies = [ShadowPixie]()
    var shadowyShadowPixies = [ShadowPixie]()
    var sprites = [SKSpriteNode]()
    let ucWorld: UCWorld

    var colorSpeedObserver: AnyCancellable!
    var drawDotsObserver: AnyCancellable!
    var outerRingRadiusObserver: AnyCancellable!
    var outerRingRollModeObserver: AnyCancellable!
    var outerRingShowRingObserver: AnyCancellable!
    var penObserver: AnyCancellable!
    var radiusObserver: AnyCancellable!
    var rollModeObserver: AnyCancellable!
    var selectionObserver: AnyCancellable!
    var showRingObserver: AnyCancellable!
    var trailDecayObserver: AnyCancellable!

    let side: Double = 1024

    init(appState: AppState, tumblerSelectorStateMachine: TumblerSelectorStateMachine) {
        _appState = ObservedObject(initialValue: appState)
        _tumblerSelectorStateMachine = ObservedObject(initialValue: tumblerSelectorStateMachine)

        ucWorld = UCWorld(width: side, height: side)
        super.init(size: ucWorld.size.cgSize)

        self.anchorPoint = .anchorAtCenter
        self.scaleMode = .aspectFit
        self.backgroundColor = .black
    }

    override func didMove(to view: SKView) {
        var ucParent = ucWorld.theWorldSpace

        for p in 0..<5 {
            let ring: AppState.Ring = p == 0 ? .outerRing : .innerRing(p)
            let pixie = Pixie(ring, skParent: self, ucParent: ucParent)

            pixie.sprite.size = ucWorld.ensize(pixie.space).cgSize
            pixie.color = SKColor([Color.orange, Color.green, Color.blue, Color.yellow, Color.red][p])

            pixies.append(pixie)

            ucParent = pixie.space
        }

        setupObservers()

        dotsQueue.async(execute: startDenseUpdate)
    }

    func startDenseUpdate() {
        dotsQueue.asyncAfter(deadline: .now() + 1.0 / 60.0, execute: denseUpdate)
    }

    override func update(_ currentTime: TimeInterval) {
        guard isReady else { return }

        for sp in liveShadowPixies { sp.dropDot(onto: self) }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension PixoniaScene {
    func denseUpdate() {
        let deltaTime: Double = 1.0 / 60.0

        let density = Int(appState.density)
        let dt = deltaTime / Double(density)

        for _ in 0..<density {
            var direction = -1.0
            var totalScale = 1.0

            for pixie in pixies {
                pixie.radiusAnimator.update(deltaTime: dt / appState.animationsDuration)
                pixie.penAnimator?.update(deltaTime: dt / appState.animationsDuration)

                if !pixie.ring.isOuterRing() {
                    // Rotation speed of the system is independent of the radius of the
                    // outermost ring
                    totalScale *= pixie.space.radius

                    // Outermost ring stays centered, regardless of its radius
                    pixie.space.position.r = 1.0 - pixie.space.radius
                }

                if pixie.showRing {
                    pixie.sprite.color = pixie.color
                    pixie.pen?.sprite.color = .red
                } else {
                    pixie.sprite.color = .clear
                    pixie.pen?.sprite.color = .clear
                }

                direction *= -1

                let rotation = direction * appState.cycleSpeed * dt * .tau / totalScale

                pixie.advance(rotation)

                let sp = ShadowPixie(ucWorld: ucWorld, pixie: pixie, appState: appState)
                sp.updatePixie(pixie)
                shadowyShadowPixies.append(sp)
            }
        }

        DispatchQueue.main.async { [weak self] in guard let myself = self else { return }
            myself.liveShadowPixies = myself.shadowyShadowPixies
            myself.shadowyShadowPixies.removeAll(keepingCapacity: true)
            myself.startDenseUpdate()
        }
    }
}

private extension PixoniaScene {
    func setupObserver<T>(
        pixoniaField: ReferenceWritableKeyPath<PixoniaScene, AnyCancellable?>,
        appStateField: ReferenceWritableKeyPath<AppState, Published<T>.Publisher>,
        pixieField: ReferenceWritableKeyPath<Pixie, T>
    ) {
        self[keyPath: pixoniaField] = appState[keyPath: appStateField].sink {
            [weak self] in self?.store($0, in: pixieField)
        }
    }

    func setupObservers() {
        setupObserver(pixoniaField: \.colorSpeedObserver, appStateField: \.$colorSpeed, pixieField: \.colorSpeed)
        setupObserver(pixoniaField: \.drawDotsObserver, appStateField: \.$drawDots, pixieField: \.drawDots)
        setupObserver(pixoniaField: \.rollModeObserver, appStateField: \.$innerRingRollMode, pixieField: \.rollMode)
        setupObserver(pixoniaField: \.showRingObserver, appStateField: \.$innerRingShow, pixieField: \.showRing)
        setupObserver(pixoniaField: \.trailDecayObserver, appStateField: \.$trailDecay, pixieField: \.trailDecay)
        setupObserver(pixoniaField: \.outerRingRollModeObserver, appStateField: \.$outerRingRollMode, pixieField: \.rollMode)
        setupObserver(pixoniaField: \.outerRingShowRingObserver, appStateField: \.$outerRingShow, pixieField: \.showRing)

        outerRingRadiusObserver = appState.$outerRingRadius.sink { [weak self] newRadius in
            guard let myself = self else { return }
            myself.pixies[0].radiusAnimator.animate(to: newRadius)
       }

        outerRingRollModeObserver = appState.$outerRingRollMode.sink { [weak self] newRollMode in
            guard let myself = self else { return }
            myself.pixies[0].rollMode = newRollMode
       }

        outerRingShowRingObserver = appState.$outerRingShow.sink { [weak self] newShow in
            guard let myself = self else { return }
            myself.pixies[0].showRing = newShow
       }

        radiusObserver = appState.$radius.sink { [weak self] newRadius in
            guard let myself = self else { return }

            for (ix, `switch`) in myself.appState.tumblerSelectorSwitches.enumerated() where `switch`.isTracking {
                myself.pixies[ix + 1].radiusAnimator.animate(to: newRadius)
            }
       }

        penObserver = appState.$pen.sink { [weak self] pen in
            guard let myself = self else { return }

            for (ix, `switch`) in myself.appState.tumblerSelectorSwitches.enumerated() where `switch`.isTracking {
                myself.pixies[ix + 1].penAnimator!.animate(to: pen)
            }
        }

        selectionObserver = tumblerSelectorStateMachine.$indexOfDrivingTumbler.sink {
            [weak self] in  guard let pscene = self, let newDriverIx = $0 else { return }

            // Charge the UI with the newly promoted tumbler
            pscene.appState.pen = pscene.pixies[newDriverIx + 1].pen!.space.position.r
            pscene.appState.colorSpeed = pscene.pixies[newDriverIx + 1].colorSpeed
            pscene.appState.drawDots = pscene.pixies[newDriverIx + 1].drawDots
            pscene.appState.radius = pscene.pixies[newDriverIx + 1].space.radius
            pscene.appState.innerRingRollMode = pscene.pixies[newDriverIx + 1].rollMode
            pscene.appState.innerRingShow = pscene.pixies[newDriverIx + 1].showRing
            pscene.appState.trailDecay = pscene.pixies[newDriverIx + 1].trailDecay

            // After the preliminary notification, the scene is finally ready to run
            pscene.isReady = true
        }
    }

    func store<T>(_ value: T, in pixieField: ReferenceWritableKeyPath<Pixie, T>) {
        for (ix, `switch`) in appState.tumblerSelectorSwitches.enumerated() where `switch`.isTracking {
            pixies[ix + 1][keyPath: pixieField] = value
        }
    }

}

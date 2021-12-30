// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import SpriteKit
import SwiftUI

class PixoniaScene: SKScene, SKSceneDelegate, ObservableObject {
    @ObservedObject var appState: AppState
    @ObservedObject var tumblerSelectorStateMachine: TumblerSelectorStateMachine

    var isReady = false

    var masterPixieForSelectorSwitches: Int?
    var previousTime: TimeInterval?
    var pixies = [Pixie]()
    var sprites = [SKSpriteNode]()
    let ucWorld: UCWorld

    var colorSpeedObserver: AnyCancellable!
    var drawDotsObserver: AnyCancellable!
    var penObserver: AnyCancellable!
    var radiusObserver: AnyCancellable!
    var rollModeObserver: AnyCancellable!
    var showRingObserver: AnyCancellable!
    var trailDecayObserver: AnyCancellable!

    var selectionObserver: AnyCancellable!

    let side: Double = 1024

    init(
        appState: ObservedObject<AppState>,
        tumblerSelectorStateMachine: ObservedObject<TumblerSelectorStateMachine>
    ) {
        self._appState = appState
        self._tumblerSelectorStateMachine = tumblerSelectorStateMachine

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

            pixie.postInit(appState: _appState)

            pixie.sprite.size = ucWorld.ensize(pixie.space).cgSize
            pixie.color = SKColor([Color.orange, Color.green, Color.blue, Color.yellow, Color.red][p])

            pixies.append(pixie)

            ucParent = pixie.space
        }

        setupObservers()
    }

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
        setupObserver(pixoniaField: \.radiusObserver, appStateField: \.$radius, pixieField: \.radius)
        setupObserver(pixoniaField: \.rollModeObserver, appStateField: \.$innerRingRollMode, pixieField: \.rollMode)
        setupObserver(pixoniaField: \.showRingObserver, appStateField: \.$innerRingShow, pixieField: \.showRing)
        setupObserver(pixoniaField: \.trailDecayObserver, appStateField: \.$trailDecay, pixieField: \.trailDecay)

        penObserver = appState.$pen.sink { [weak self] pen in
            guard let myself = self else { return }

            for (ix, `switch`) in myself.appState.tumblerSelectorSwitches.enumerated() where `switch`.isTracking {
                myself.pixies[ix + 1].pen!.space.position.r = pen
                myself.pixies[ix + 1].applyStateNeeded = true
            }
        }

        selectionObserver = tumblerSelectorStateMachine.$indexOfDrivingTumbler.sink {
            [weak self] in
            guard let pscene = self else { return }
            guard let newDriverIx = $0 else { return }

            // Charge the UI with the newly promoted tumbler
            pscene.appState.pen = pscene.pixies[newDriverIx + 1].pen!.space.position.r
            pscene.appState.colorSpeed = pscene.pixies[newDriverIx + 1].colorSpeed
            pscene.appState.drawDots = pscene.pixies[newDriverIx + 1].drawDots
            pscene.appState.radius = pscene.pixies[newDriverIx + 1].radius
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
            pixies[ix + 1].applyStateNeeded = true
        }
    }

    override func update(_ currentTime: TimeInterval) {
        defer { previousTime = currentTime }
        guard isReady else { return }
        let deltaTime: Double = 1.0 / 60.0

        let density = Int(appState.density)
        let dt = deltaTime / Double(density)

        for _ in 0..<density {
            var direction = 1.0
            var totalScale = 1.0

            for pixie in pixies {
                pixie.applyUIStateToPixieStateIf(appState)

                direction *= -1

                // Don't scale the rotation for the outer ring's radius; the rotation rate
                // is always the same no matter its size
                if !pixie.ring.isOuterRing() { totalScale *= pixie.space.radius }

                let rotation = 2.0 * direction * appState.cycleSpeed * dt * .tau / totalScale

                pixie.advance(rotation)
                pixie.reify(ucWorld: ucWorld)
                pixie.dropDot(onto: self, ucWorld: ucWorld, deltaTime: dt)
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

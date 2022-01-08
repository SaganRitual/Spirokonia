// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import SpriteKit
import SwiftUI

class PixoniaScene: SKScene, SKSceneDelegate, ObservableObject {
    @ObservedObject var appModel: AppModel
    @ObservedObject var tumblerSelectorStateMachine: TumblerSelectorStateMachine

    let dotsQueue = DispatchQueue(
        label: "scene.pixonia", attributes: .concurrent, target: DispatchQueue.global()
    )

    let radius: Double = 2048
    var isReady = false

    var previousTime: TimeInterval?
    var pixies = [Pixie]()
    var sprites = [SKSpriteNode]()
    let space: UCSpace

    var colorSpeedObserver: AnyCancellable!
    var drawDotsObserver: AnyCancellable!
    var outerRingRadiusObserver: AnyCancellable!
    var outerRingRollModeObserver: AnyCancellable!
    var outerRingShowRingObserver: AnyCancellable!
    var penObserver: AnyCancellable!
    var radiusObserver: AnyCancellable!
    var rollModeObserver: AnyCancellable!
    var rollRelationshipObserver: AnyCancellable!
    var selectionObserver: AnyCancellable!
    var showRingObserver: AnyCancellable!
    var trailDecayObserver: AnyCancellable!

    var accumulatingSnapshots = [PixieSnapshot]()
    var readySnapshots = [PixieSnapshot]()

    init(appModel: AppModel, tumblerSelectorStateMachine: TumblerSelectorStateMachine) {
        _appModel = ObservedObject(initialValue: appModel)
        _tumblerSelectorStateMachine = ObservedObject(initialValue: tumblerSelectorStateMachine)

        space = UCSpace(radius: radius)
        super.init(size: space.cgSize)

        self.anchorPoint = .anchorAtCenter
        self.scaleMode = .aspectFit
        self.backgroundColor = .black
    }

    override func didMove(to view: SKView) {
        var ucParent = self.space

        for p in 0..<5 {
            let ring: AppDefinitions.Ring = p == 0 ? .outerRing : .innerRing(p)
            let pixie = Pixie(ring, skParent: self, ucParent: ucParent, appModel: appModel)

//            pixie.sprite.size = ucWorld.ensize(pixie.space).cgSize
            pixie.color = SKColor(AppDefinitions.ringColors[p])

            pixies.append(pixie)

            ucParent = pixie.space
        }

        pixies[1].postInit(connectTo: [pixies[2], pixies[3], pixies[4]])
        pixies[2].postInit(connectTo: [pixies[3], pixies[4], pixies[1]])
        pixies[3].postInit(connectTo: [pixies[4], pixies[1], pixies[2]])
        pixies[4].postInit(connectTo: [pixies[1], pixies[2], pixies[3]])

        dotsQueue.async(execute: startDenseUpdate)
    }

    func startDenseUpdate() {
        dotsQueue.asyncAfter(deadline: .now() + 1.0 / 60.0, execute: denseUpdate)
    }

    override func update(_ currentTime: TimeInterval) {
        guard isReady else { return }

        for snapshot in readySnapshots {
            snapshot.dropDot(onto: self)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension PixoniaScene {
    func denseUpdate() {
        let deltaTime: Double = 1.0 / 60.0

        let density = Int(appModel.density)
        let dt = deltaTime / Double(density)

        for _ in 0..<density {
            var direction = -1.0
            var totalScale = 1.0

            for pixie in pixies {
                pixie.radiusAnimator.update(deltaTime: dt / appModel.animationsDuration)
                pixie.penAnimator?.update(deltaTime: dt / appModel.animationsDuration)

                // Inner rings rotation speed and position are dependent on their radii, while
                // the outer ring's rotation speed is strictly a function of the main cycle speed
                // slider, and its position is always zero
                if !pixie.ring.isOuterRing() {
                    totalScale *= pixie.space.radius
                    pixie.space.position.r = 1.0 - pixie.space.radius

                    pixie.connectors.forEach {
                        $0.nib.space.position.r = pixie.penR
                    }
                }

                pixie.showHideRing()
                pixie.showHidePen()
                pixie.calculateColor(dt)

                direction *= -1
//                if pixie.settingsModel.rollRelationship == .outerToOuter { direction *= -1 }

                let rotation = direction * appModel.cycleSpeed * dt * .tau / totalScale

                pixie.advance(rotation)
                pixie.reify(to: space)

                accumulatingSnapshots.append(PixieSnapshot(space: space, pixie: pixie))
            }
        }

        DispatchQueue.main.async { [weak self] in guard let myself = self else { return }
            // FIXME: initialization order issues
            myself.isReady = true

            myself.readySnapshots = myself.accumulatingSnapshots
            myself.accumulatingSnapshots.removeAll(keepingCapacity: true)
            myself.startDenseUpdate()
        }
    }
}

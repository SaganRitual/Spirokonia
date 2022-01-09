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

    var pixieHarness: PixieHarness!
    var previousTime: TimeInterval?

    var accumulatingSnapshots = [PixieHarnessSnapshot]()
    var readySnapshots = [PixieHarnessSnapshot]()

    init(appModel: AppModel, tumblerSelectorStateMachine: TumblerSelectorStateMachine) {
        _appModel = ObservedObject(initialValue: appModel)
        _tumblerSelectorStateMachine = ObservedObject(initialValue: tumblerSelectorStateMachine)

        super.init(size: CGSize(width: radius * 2, height: radius * 2))

        pixieHarness = PixieHarness(pixoniaScene: self, appModel: appModel)

        self.anchorPoint = .anchorAtCenter
        self.scaleMode = .aspectFit
        self.backgroundColor = .black
    }

    override func didMove(to view: SKView) {
        startDenseUpdate()
    }

    func startDenseUpdate() {
        dotsQueue.async(execute: denseUpdate)
    }

    override func update(_ currentTime: TimeInterval) {
        defer { previousTime = currentTime }
        guard let previousTime = previousTime else { return }
        let deltaTime = currentTime - previousTime

        pixieHarness.platterPixie.core.radiusAnimator.update(deltaTime: deltaTime)
        pixieHarness.platterPixie.core.showRing(appModel.outerRingShow)

        pixieHarness.drawingPixies.forEach {
            $0.core.radiusAnimator.update(deltaTime: deltaTime / AppDefinitions.animationsDuration)
            $0.penPositionRAnimator.update(deltaTime: deltaTime / AppDefinitions.animationsDuration)

            $0.showHidePen()
            $0.core.showRing($0.settingsModel.showRing)
        }

        for snapshot in readySnapshots {
            for (pixie, pixieSnapshot) in
                    zip(pixieHarness.drawingPixies, snapshot.drawingSnapshots) where
                    pixie.settingsModel.drawDots == true {
                pixie.dropDot(pixieSnapshot)
            }
        }

        startDenseUpdate()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct RSnapshot {
    let rsDrawingPixies: [DrawingPixie.RSnapshot]
    let rsPlatter: Supersprite.RSnapshot
}

private extension PixoniaScene {
    func denseUpdate() {
        let deltaTime: Double = 1.0 / 60.0

        let density = Int(appModel.density)
        let dt = deltaTime / Double(density)

        for _ in 0..<density {
            pixieHarness.advance(by: dt)
            accumulatingSnapshots.append(pixieHarness.makeSnapshot())
        }

        DispatchQueue.main.async { [weak self] in guard let myself = self else { return }
            myself.readySnapshots = myself.accumulatingSnapshots
            myself.accumulatingSnapshots.removeAll(keepingCapacity: true)
        }
    }
}

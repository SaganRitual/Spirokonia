// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import SpriteKit

class PixieHarness {
    let appModel: AppModel
    let drawingPixies: [DrawingPixie]
    let pixoniaScene: PixoniaScene
    let platterPixie: PlatterPixie

    let dotsQueue = DispatchQueue(
        label: "dotsQueue", attributes: .concurrent, target: DispatchQueue.global()
    )

    private var dotSnapshotsInProgress = [DotSnapshot]()
    var readyDotSnapshots = [DotSnapshot]()
    var dotSnapshotsReady = false

    init(pixoniaScene: PixoniaScene, appModel: AppModel) {
        self.appModel = appModel
        self.pixoniaScene = pixoniaScene

        platterPixie = PlatterPixie(
            radius: appModel.outerRingRadius, color: SKColor(AppDefinitions.platterPixieColor),
            skParent: pixoniaScene, pixoniaScene: pixoniaScene
        )

        platterPixie.postInit(appModel)

        var parent = platterPixie.sprite

        drawingPixies = (0..<4).map { ix in
            let newPixie = DrawingPixie(
                ix: ix,
                radius: appModel.drawingTumblerSettingsModels.tumblerSettingsModels[ix].radius,
                color: SKColor(AppDefinitions.drawingPixieColors[ix]), skParent: parent,
                pixoniaScene: pixoniaScene
            )

            newPixie.postInit(appModel)

            parent = newPixie.sprite
            return newPixie
        }
    }
}

extension PixieHarness {
    func startDenseUpdate() {
        dotsQueue.async(execute: denseUpdate)
    }

    func denseUpdate() {
        let density = Int(appModel.density)

        (0..<density).forEach { _ in advance(by: 1.0 / 60.0 / Double(density)) }

        DispatchQueue.main.sync { [weak self] in
            guard let myself = self else { return }
            myself.readyDotSnapshots.append(contentsOf: myself.dotSnapshotsInProgress)
            myself.dotSnapshotsInProgress.removeAll(keepingCapacity: true)
        }
    }

    func dropDots() {
        for snapshot in readyDotSnapshots {
            let fadeDuration = 0.5
            guard snapshot.trailDecay - fadeDuration > 0 else { continue }

            let dot = SpritePool.dots.makeSprite()
            dot.color = snapshot.color
            dot.position = snapshot.dotPosition
            dot.size = CGSize(width: 10, height: 10)
            dot.zPosition = snapshot.dotZ

            if dot.parent == nil {
                pixoniaScene.addChild(dot)
            }

            let delay = SKAction.wait(forDuration: snapshot.trailDecay - fadeDuration)
            let fade = SKAction.fadeOut(withDuration: fadeDuration)
            let action = SKAction.sequence([delay, fade])
            dot.run(action) { SpritePool.dots.releaseSprite(dot, fullSKRemove: false) }
        }

        readyDotSnapshots.removeAll(keepingCapacity: true)
        startDenseUpdate()
    }
}

extension PixieHarness {
    func advance(by deltaTime: Double) {
        var direction = 1.0
        var rotation = deltaTime * appModel.cycleSpeed * .tau

        platterPixie.advance(by: direction * rotation)

        for pixie in drawingPixies {
            direction *= -1.0
            rotation /= pixie.hotRadius

            pixie.advance(by: direction * rotation)

            if pixie.settingsModel.drawDots {
                dotSnapshotsInProgress.append(
                    pixie.takeSnapshot(deltaTime: deltaTime, pixoniaScene: pixoniaScene)
                )
            }
        }
    }
}

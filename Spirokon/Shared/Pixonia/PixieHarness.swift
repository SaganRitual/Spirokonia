// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import SpriteKit

class PixieHarness {
    let appModel: AppModel
    var drawingBelles = [DrawingBelle]()
    let pixoniaScene: PixoniaScene
    let platterBelle: Belle

    let dotsQueue = DispatchQueue(
        label: "dotsQueue", attributes: .concurrent, target: DispatchQueue.global()
    )

    private var dotSnapshotsInProgress = [DotSnapshot]()
    var readyDotSnapshots = [DotSnapshot]()

    var dotSnapshotsReady = false

    private var inDenseUpdate_ = false
    var inDenseUpdate: Bool {
        get {
            // This has to be totally synchronous with the SpriteKit update
            dispatchPrecondition(condition: .onQueue(DispatchQueue.main))
            return inDenseUpdate_
        }

        set {
            // This has to be totally synchronous with the SpriteKit update
            dispatchPrecondition(condition: .onQueue(DispatchQueue.main))
            inDenseUpdate_ = newValue
        }
    }

    init(pixoniaScene: PixoniaScene, appModel: AppModel) {
        self.appModel = appModel
        self.pixoniaScene = pixoniaScene

        platterBelle = PlatterBelle(
            pixoniaScene: pixoniaScene, spritePool: .crosshairRings2048x2048x24,
            color: SKColor(AppDefinitions.platterPixieColor)
        )

        platterBelle.postInit(appModel)

        var parent = platterBelle

        drawingBelles = (0..<4).map { ix in
            let newBelle = DrawingBelle(
                ix: ix,
                radius: appModel.drawingTumblerSettingsModels.tumblerSettingsModels[ix].radius,
                color: SKColor(AppDefinitions.drawingPixieColors[ix]), skParent: pixoniaScene,
                pixoniaScene: pixoniaScene
            )

            newBelle.postInit(appModel)
            parent.addChild(newBelle)
            parent = newBelle
            return newBelle
        }
    }
}

extension PixieHarness {
    func startDenseUpdate() {
        if !inDenseUpdate {
            inDenseUpdate = true
            dotsQueue.async(execute: denseUpdate)
        }
    }

    func denseUpdate() {
        let density = Int(appModel.density)

        (0..<density).forEach { _ in advance(by: 1.0 / 60.0 / Double(density)) }

        DispatchQueue.main.sync { [weak self] in
            guard let myself = self else { return }
            myself.readyDotSnapshots.append(contentsOf: myself.dotSnapshotsInProgress)
            myself.dotSnapshotsInProgress.removeAll(keepingCapacity: true)
            myself.inDenseUpdate = false
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
    }

    func update() {
        let deltaTime = 1.0 / 60.0

        drawingBelles.forEach { $0.update(deltaTime: deltaTime) }
        platterBelle.update(deltaTime: deltaTime)

        dropDots()
        startDenseUpdate()
    }
}

extension PixieHarness {
    func advance(by deltaTime: Double) {
        platterBelle.advance(
            by: deltaTime, masterCycleSpeed: appModel.cycleSpeed, scale: 1.0, direction: 1.0
        )

        platterBelle.reify(scale: pixoniaScene.radius * platterBelle.radius)

        for belle in drawingBelles where belle.settingsModel.drawDots {
            dotSnapshotsInProgress.append(
                belle.takeSnapshot(deltaTime: deltaTime, pixoniaScene: pixoniaScene)
            )
        }
    }
}

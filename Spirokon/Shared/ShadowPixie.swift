// We are a way for the cosmos to know itself. -- C. Sagan

import SpriteKit
import SwiftUI

struct ShadowPixie {
    let dotColor: YAColor
    let dotZ: Double
    let drawDots: Bool
    let penPosition: CGPoint
    let position: CGPoint
    let size: CGSize
    let trailDecay: Double
    let zRotation: Double

    init(ucWorld: UCWorld, pixie: Pixie, appState: AppState) {
        let deltaTime = 1.0 / 60.0

        size = ucWorld.ensize(pixie.space).cgSize
        position = ucWorld.emplace(pixie.space).cgPoint
        zRotation = ucWorld.emroll(pixie.space)
        drawDots = pixie.drawDots

        let colorRotation = pixie.colorSpeed * deltaTime * .tau / appState.density
        dotColor = pixie.currentDotColor.rotateHue(byAngle: colorRotation)

        let dotZ = pixie.dotZ + 1e-4
        self.dotZ = dotZ > 1.0 ? 0.0 : dotZ

        trailDecay = pixie.trailDecay

        if let pen = pixie.pen {
            penPosition = ucWorld.emplace(pen.space).cgPoint
        } else {
            penPosition = .zero
        }
    }

    func dropDot(onto scene: SKScene) {
        guard drawDots else { return }

        let dot = SpritePool.dots.makeSprite()
        dot.size = CGSize(width: 3, height: 3)

        dot.zPosition = dotZ
        dot.position = penPosition
        dot.color = dotColor

        if dot.parent == nil { scene.addChild(dot) }

        let fadeTime = 0.5
        assert(trailDecay - fadeTime > 0)
        let delay = SKAction.wait(forDuration: trailDecay - fadeTime)
        let fade = SKAction.fadeOut(withDuration: fadeTime)
        let sequence = SKAction.sequence([delay, fade])

        dot.run(sequence) { SpritePool.dots.releaseSprite(dot, fullSKRemove: false) }
    }

    func updatePixie(_ pixie: Pixie) {
        pixie.sprite.position = self.position
        pixie.sprite.size = self.size
        pixie.sprite.zRotation = self.zRotation
        pixie.currentDotColor = self.dotColor
        pixie.dotZ = self.dotZ

        pixie.pen?.sprite.position = self.penPosition
    }
}

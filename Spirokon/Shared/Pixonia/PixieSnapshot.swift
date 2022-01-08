// We are a way for the cosmos to know itself. -- C. Sagan

import SpriteKit
import SwiftUI

struct PixieSnapshot {
    let dotColor: YAColor
    let dotPosition: CGPoint
    let dotZ: Double
    let drawDots: Bool
    let pixie: Pixie
    let position: CGPoint
    let size: CGSize
    let trailDecay: Double
    let zRotation: Double

    init(space: UCSpace, pixie: Pixie) {
        self.pixie = pixie

        drawDots = pixie.drawDots
        dotColor = pixie.currentDotColor

        dotPosition = pixie.connectors.isEmpty ?
            .zero : pixie.connectors[pixie.penAxis].nib.sprite.position

        let dotZ = pixie.dotZ + 1e-4
        self.dotZ = dotZ > 1.0 ? 0.0 : dotZ

        trailDecay = pixie.trailDecay
        position = pixie.sprite.position
        zRotation = pixie.sprite.zRotation
        size = pixie.sprite.size
    }

    func dropDot(onto scene: SKScene) {
        guard drawDots else { return }

        let dot = SpritePool.dots.makeSprite()
        dot.size = CGSize(width: 10, height: 10)

        dot.zPosition = dotZ
        dot.position = pixie.connectors[pixie.penAxis].sprite.convert(dotPosition, to: scene)
        dot.color = dotColor

        if dot.parent == nil { scene.addChild(dot) }

        let fadeTime = 0.5
        assert(trailDecay - fadeTime > 0)
        let delay = SKAction.wait(forDuration: trailDecay - fadeTime)
        let fade = SKAction.fadeOut(withDuration: fadeTime)
        let sequence = SKAction.sequence([delay, fade])

        dot.run(sequence) { SpritePool.dots.releaseSprite(dot, fullSKRemove: false) }
    }
}

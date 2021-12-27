// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import SpriteKit
import SwiftUI

class Pixie {
    let ring: AppState.Ring
    let sprite: SKSpriteNode

    var color = SKColor.green
    var colorSpeed = 0.0
    var density = 0.0
    var drawDots = false
    var firstPass = true
    var pen = 0.0
    var radius = 0.0
    var rollMode = AppState.RollMode.normal
    var showRing = false
    var trailDecay = 0.0

    init(_ ring: AppState.Ring, parent: SKNode) {
        self.ring = ring

        switch ring {
        case .outerRing:
            sprite = SpritePool.spokeRingsLarge.makeSprite()

        case .innerRing(1):
            sprite = SpritePool.spokeRingsLarge.makeSprite()

        case .innerRing(2), .innerRing(3):
            sprite = SpritePool.spokeRingsMedium.makeSprite()

        case .innerRing(4):
            sprite = SpritePool.spokeRingsSmall.makeSprite()

        default: fatalError()
        }

        sprite.anchorPoint = .anchorAtCenter
        parent.addChild(sprite)

        if let p = parent as? SKScene {
            sprite.size = p.size
        } else if let p = parent as? SKSpriteNode {
            sprite.size = p.size
        } else {
            assert(false)
        }
    }

    func applyPixieStateToSprite() {
        sprite.color = showRing ? self.color : .clear
        sprite.setScale(self.radius)
    }

    func applyUIStateToPixieStateIf(_ appState: AppState) {
        switch ring {
        case .outerRing:
            self.radius = appState.outerRingRadius
            self.rollMode = appState.outerRingRollMode
            self.showRing = appState.showRingOuter

        case .innerRing:
            break
        }
    }

    func dropDot(onto scene: SKScene) {
        guard drawDots else { return }

        let dot = SpritePool.dots.makeSprite()
        dot.size = CGSize(width: 5, height: 5)
        dot.color = self.color
        dot.position = sprite.convert(CGPoint(x: scene.size.width / 2, y: 0), to: scene)

        scene.addChild(dot)

        dot.run(SKAction.fadeOut(withDuration: 5.0)) {
            SpritePool.dots.releaseSprite(dot)
        }
    }

    func postInit(appState: ObservedObject<AppState>) {
        switch ring {
        case .outerRing:
            self.radius = appState.wrappedValue.outerRingRadius
            self.rollMode = appState.wrappedValue.outerRingRollMode
            self.showRing = appState.wrappedValue.showRingOuter

        default:
            self.radius = appState.wrappedValue.radius
            self.pen = appState.wrappedValue.pen
        }
    }

    func roll(_ rotation: Double) {
        switch rollMode {
        case .normal:      sprite.zRotation += rotation * 0.5
        case .compensate:  sprite.zRotation += rotation
        case .fullStop:    break
        case .doesNotRoll: break
        }
    }
}

// We are a way for the cosmos to know itself. -- C. Sagan

import SpriteKit
import SwiftUI

class Pixie {
    var radius = 0.0
    let ring: AppState.Ring
    let sprite: SKSpriteNode

    init(_ ring: AppState.Ring, parent: SKNode) {
        self.ring = ring

        switch ring {
        case .outerRing:
            sprite = SpritePool.plainRings.makeSprite()

        case .innerRing(1):
            sprite = SpritePool.spokeRingsLarge.makeSprite()

        case .innerRing(2), .innerRing(3), .innerRing(4):
            sprite = SpritePool.spokeRingsSmall.makeSprite()

        default: fatalError()
        }

        if case AppState.Ring.innerRing = ring {
            radius = 0.5
        } else {
            radius = 1.0
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

    func dropDot(onto scene: SKScene) {
        let dot = SpritePool.dots.makeSprite()
        dot.size = CGSize(width: 5, height: 5)
        dot.color = sprite.color
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

            radiusObserver = appState.projectedValue.$outerRingRadius.wrappedValue.sink {
                [weak self] in self?.radius = $0
            }

            rollModeObserver = appState.projectedValue.$outerRingRollMode.wrappedValue.sink {
                [weak self] in self?.rollMode = $0
            }

            showRingObserver = appState.projectedValue.$showRingOuter.wrappedValue.sink {
                [weak self] in self?.showRing = $0
            }

        default: break
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

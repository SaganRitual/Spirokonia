// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import SpriteKit
import SwiftUI

class Pen {
    let sprite: SKSpriteNode
    var space = UCSpace()

    init(skParent: PixoniaScene, ucParent: UCSpace) {
        sprite = SpritePool.dots.makeSprite()
        sprite.size = CGSize(width: 10, height: 10)
        sprite.color = .red

        skParent.addChild(sprite)
        ucParent.addChild(space)
    }
}

class Pixie {
    let ring: AppState.Ring
    let sprite: SKSpriteNode

    var pen: Pen!
    var space = UCSpace()

    var color = SKColor.green
    var colorSpeed = 0.0
    var currentDotColor = YAColor(hue: 0.0, saturation: 1.0, brightness: 1.0, alpha: 1.0)
    var density = 0.0
    var drawDots = false
    var firstPass = true
    var radius = 0.0
    var rollMode = AppState.RollMode.normal
    var showRing = false
    var trailDecay = 0.0

    var isOuterRing: Bool {
        switch ring {
        case .outerRing: return true
        case .innerRing: return false
        }
    }

    var isInnerRing: Bool {
        switch ring {
        case .outerRing: return false
        case .innerRing: return true
        }
    }

    init(_ ring: AppState.Ring, skParent: PixoniaScene, ucParent: UCSpace) {
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
        skParent.addChild(sprite)
        ucParent.addChild(space)

        pen = Pen(skParent: skParent, ucParent: self.space)
    }

    func applyPixieStateToSprite(ucWorld: UCWorld) {
        sprite.color = showRing ? self.color : .clear

        sprite.size = ucWorld.ensize(space).cgSize
        sprite.position = ucWorld.emplace(space).cgPoint
        sprite.zRotation = ucWorld.emroll(space)

        pen.sprite.position = ucWorld.emplace(pen.space).cgPoint
    }

    func applyUIStateToPixieStateIf(_ appState: AppState) {
        switch ring {
        case .outerRing:
            space.radius = appState.outerRingRadius
            self.rollMode = appState.outerRingRollMode
            self.showRing = appState.showRingOuter

        case .innerRing:
            space.radius = appState.radius
            space.position.r = 1.0 - space.radius
            pen.space.position.r = appState.pen
        }
    }

    func dropDot(onto scene: SKScene, ucWorld: UCWorld, deltaTime: Double) {
        guard drawDots else { return }

        let dot = SpritePool.dots.makeSprite()
        dot.size = CGSize(width: 5, height: 5)

        let colorRotation = 2.0 * colorSpeed * deltaTime * .tau
        currentDotColor = currentDotColor.rotateHue(byAngle: colorRotation)

        dot.color = currentDotColor
        dot.position = ucWorld.emplace(pen.space).cgPoint

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
            self.pen.space.position.r = appState.wrappedValue.pen
        }
    }

    func roll(_ rotation: Double) {
        switch rollMode {
        case .normal:      space.rotation += rotation * 0.5
        case .compensate:  space.rotation += rotation
        case .fullStop:    break
        case .doesNotRoll: break
        }
    }
}

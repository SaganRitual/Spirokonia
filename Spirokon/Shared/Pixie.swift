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

    var pen: Pen?
    var space = UCSpace()

    var color = SKColor.green
    var colorSpeed = 0.0
    var currentDotColor = YAColor(hue: 0.0, saturation: 1.0, brightness: 1.0, alpha: 1.0)
    var drawDots = false
    var firstPass = true
    var rollMode = AppState.RollMode.normal
    var showRing = false
    var trailDecay = 0.0

    var applyStateNeeded = true

    let penAnimator: Animator?
    let radiusAnimator: Animator

    init(_ ring: AppState.Ring, skParent: PixoniaScene, ucParent: UCSpace) {
        self.ring = ring

        switch ring {
        case .outerRing:
            sprite = SpritePool.crosshairRingsLarge.makeSprite()
            radiusAnimator = Animator(1.0, for: sprite)

            pen = nil
            penAnimator = nil

        case .innerRing(1):
            sprite = SpritePool.crosshairRingsLarge.makeSprite()
            radiusAnimator = Animator(0.5, for: sprite)
            penAnimator = Animator(1.0, for: sprite)

            colorSpeed = 0.1
            trailDecay = 10

        case .innerRing(2), .innerRing(3):
            sprite = SpritePool.crosshairRingsLarge.makeSprite()
            radiusAnimator = Animator(0.5, for: sprite)
            penAnimator = Animator(1.0, for: sprite)

            colorSpeed = 0.1
            trailDecay = 1

        case .innerRing(4):
            sprite = SpritePool.crosshairRingsLarge.makeSprite()
            radiusAnimator = Animator(0.5, for: sprite)
            penAnimator = Animator(1.0, for: sprite)

            colorSpeed = 0.1
            trailDecay = 1

        default: fatalError()
        }

        skParent.addChild(sprite)
        ucParent.addChild(space)

        if ring.isInnerRing() {
            pen = Pen(skParent: skParent, ucParent: self.space)
        }
    }

    func advance(_ rotation: Double) {
        switch rollMode {
        case .normal:      space.rotation += rotation
        case .compensate:  space.rotation += rotation * 0.5
        case .fullStop:    break
        case .doesNotRoll: break
        }
    }

    func applyUIStateToPixieStateIf(_ appState: AppState) {
        defer { applyStateNeeded = false }

        switch ring {
        case .outerRing:
            self.space.radius = radiusAnimator.currentValue
            self.rollMode = appState.outerRingRollMode
            self.showRing = appState.outerRingShow

        case .innerRing(let ix):
            space.radius = radiusAnimator.currentValue
            space.position.r = 1.0 - space.radius

            pen!.space.position.r = penAnimator!.currentValue

            guard appState.tumblerSelectorSwitches[ix - 1] == .trueDefinite &&
                  applyStateNeeded else { return }

            colorSpeed = appState.colorSpeed
            drawDots = appState.drawDots
            rollMode = appState.innerRingRollMode
            showRing = appState.innerRingShow
            trailDecay = appState.trailDecay
        }
    }

    func dropDot(onto scene: SKScene, ucWorld: UCWorld, deltaTime: Double) {
        guard drawDots, ring.isInnerRing() else { return }

        // If the trail decay is really small, just don't put down a dot
        let fadeTime = 0.5
        let oneFrameTime = 1.0 / 60.0
        if trailDecay < fadeTime + oneFrameTime { return }

        let dot = SpritePool.dots.makeSprite()
        dot.size = CGSize(width: 3, height: 3)

        let colorRotation = colorSpeed * deltaTime * .tau
        currentDotColor = currentDotColor.rotateHue(byAngle: colorRotation)

        dot.color = currentDotColor
        dot.position = ucWorld.emplace(pen!.space).cgPoint

        scene.addChild(dot)

        let delay = SKAction.wait(forDuration: trailDecay - fadeTime)
        let fade = SKAction.fadeOut(withDuration: fadeTime)
        let sequence = SKAction.sequence([delay, fade])

        dot.run(sequence) { SpritePool.dots.releaseSprite(dot) }
    }

    func postInit(appState: ObservedObject<AppState>) {
        switch ring {
        case .outerRing:
            self.radiusAnimator.currentValue = appState.wrappedValue.outerRingRadius
            self.rollMode = appState.wrappedValue.outerRingRollMode
            self.showRing = appState.wrappedValue.outerRingShow

        default:
            self.penAnimator!.currentValue = appState.wrappedValue.pen
            self.radiusAnimator.currentValue = appState.wrappedValue.radius
        }
    }

    func reify(ucWorld: UCWorld) {
        sprite.color = showRing ? self.color : .clear

        sprite.size = ucWorld.ensize(space).cgSize
        sprite.position = ucWorld.emplace(space).cgPoint
        sprite.zRotation = ucWorld.emroll(space)

        guard let pen = pen else { return }

        pen.sprite.position = ucWorld.emplace(pen.space).cgPoint
        pen.sprite.color = showRing ? .red : .clear
    }
}

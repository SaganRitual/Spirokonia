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
        sprite.zPosition = 1.0

        skParent.addChild(sprite)
        ucParent.addChild(space)
    }
}

class Pixie {
    let ring: AppState.Ring
    let sprite: SKSpriteNode

    var pen: Pen?
    var space = UCSpace()
    var dotZ = 0.0

    var color = SKColor.green
    var colorSpeed = 0.0
    var currentDotColor = YAColor(hue: 0.0, saturation: 1.0, brightness: 1.0, alpha: 1.0)
    var drawDots = false
    var firstPass = true
    var rollMode = AppState.RollMode.normal
    var showRing = false
    var trailDecay = 0.0

    let penAnimator: Animator<UCSpace>?
    let radiusAnimator: Animator<UCSpace>

    init(_ ring: AppState.Ring, skParent: PixoniaScene, ucParent: UCSpace) {
        self.ring = ring

        if ring.isInnerRing() {
            pen = Pen(skParent: skParent, ucParent: self.space)

            space.radius = 0.5
            pen!.space.position.r = 1.0
        }

        switch ring {
        case .outerRing:
            sprite = SpritePool.crosshairRingsLarge.makeSprite()
            radiusAnimator = Animator(\.radius, for: self.space)

            pen = nil
            penAnimator = nil

        case .innerRing(1):
            sprite = SpritePool.crosshairRingsLarge.makeSprite()
            radiusAnimator = Animator(\.radius, for: self.space)
            penAnimator = Animator(\.position.r, for: self.pen!.space)

            colorSpeed = 0.1
            trailDecay = 10

        case .innerRing(2), .innerRing(3):
            sprite = SpritePool.crosshairRingsLarge.makeSprite()
            radiusAnimator = Animator(\.radius, for: self.space)
            penAnimator = Animator(\.position.r, for: self.pen!.space)

            colorSpeed = 0.1
            trailDecay = 1

        case .innerRing(4):
            sprite = SpritePool.crosshairRingsLarge.makeSprite()
            radiusAnimator = Animator(\.radius, for: self.space)
            penAnimator = Animator(\.position.r, for: self.pen!.space)

            colorSpeed = 0.1
            trailDecay = 1

        default: fatalError()
        }

        sprite.zPosition = Double(-ring.ix)

        skParent.addChild(sprite)
        ucParent.addChild(space)
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
        switch ring {
        case .outerRing:
            self.rollMode = appState.outerRingRollMode
            self.showRing = appState.outerRingShow

        case .innerRing(let ix):
            space.position.r = 1.0 - space.radius

            guard appState.tumblerSelectorSwitches[ix - 1] == .trueDefinite else { return }
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

        dotZ += 1e-4
        if dotZ > 1.0 { dotZ = 0.0 }

        dot.zPosition = Double(-ring.ix) + dotZ
        dot.position = ucWorld.emplace(pen!.space).cgPoint
        dot.color = currentDotColor

        if dot.parent == nil {
            scene.addChild(dot)
        }

        let delay = SKAction.wait(forDuration: trailDecay - fadeTime)
        let fade = SKAction.fadeOut(withDuration: fadeTime)
        let sequence = SKAction.sequence([delay, fade])

        dot.run(sequence) { SpritePool.dots.releaseSprite(dot, fullSKRemove: false) }
    }

    func postInit(appState: ObservedObject<AppState>) {
        switch ring {
        case .outerRing:
            self.rollMode = appState.wrappedValue.outerRingRollMode
            self.showRing = appState.wrappedValue.outerRingShow

        default:
            break
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

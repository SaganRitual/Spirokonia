// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import SpriteKit

class Belle: UCSpace {
    private let sprite: SKSpriteNode
    private let textureScale: Double

    let pixoniaScene: PixoniaScene
    let suppressScaling: Bool

    var radiusAnimator: Animator<UCSpace>!
    var radiusObserver: AnyCancellable!
    var radiusPublisher: Published<Double>.Publisher!

    let color: SKColor

    var reifiedPosition: CGPoint { sprite.position }

    var isReady = false

    init(
        pixoniaScene: PixoniaScene, spritePool: SpritePool,
        color: SKColor, suppressScaling: Bool = false
    ) {
        self.color = color
        self.pixoniaScene = pixoniaScene
        self.suppressScaling = suppressScaling

        sprite = spritePool.makeSprite()
        pixoniaScene.addChild(sprite)

        let textureRadius = spritePool.texture.size().width / 2
        textureScale = textureRadius / pixoniaScene.radius

        super.init(name: "Belle space")
    }

    func advance(
        by deltaTime: Double, masterCycleSpeed: Double, scale: Double, direction: Double,
        compensation: Double = 0.0
    ) {
        advance(
            by: deltaTime, masterCycleSpeed: masterCycleSpeed, scale: scale,
            direction: direction, rollMode: .doesNotRoll,
            compensation: compensation
        )
    }

    func advance(
        by deltaTime: Double, masterCycleSpeed: Double, scale: Double, direction: Double,
        rollMode: AppDefinitions.RollMode, compensation: Double = 0.0
    ) {
        let naturalRotation = deltaTime * masterCycleSpeed * direction * .tau

        switch rollMode {
        case .compensate:
            rotation += 0
        case .cycloid:
            rotation += naturalRotation * scale + compensation
        case .doesNotRoll:
            return
        case .fullStop:
            rotation += 0
        case .sticky:
            rotation += naturalRotation * direction
        case .flattened:
            rotation += naturalRotation * scale
        }

        for child in children.compactMap({ $0 as? Belle }) {
            child.advance(
                by: deltaTime, masterCycleSpeed: masterCycleSpeed,
                scale: scale / child.radius, direction: direction * -1.0,
                compensation: naturalRotation * scale + compensation
            )
        }
    }

    func postInit(_ appModel: AppModel) {
        assert(
            radiusPublisher != nil,
            "Child classes must instantiate the publisher before coming here"
        )

        radiusAnimator = Animator(\.radius, for: self)

        radiusObserver =
            radiusPublisher.sink {
                [weak self] newRadius in guard let myself = self else { return }
                if myself.isReady {
                    myself.radiusAnimator.animate(to: newRadius)
                } else {
                    // First time through, set the sizes before we start rolling
                    myself.radius = newRadius
                    myself.isReady = true
                }
            }
    }

    func reify(scale: Double) {
        sprite.zRotation = rotation

        if suppressScaling {
            sprite.size = CGSize(width: radius * 2.0, height: radius * 2.0)
        } else {
            let reifiedRadius = scale
            sprite.size = CGSize(width: reifiedRadius * 2.0, height: reifiedRadius * 2.0)
        }

        for child in children.compactMap({ $0 as? Belle }) {
            let childRadius = child.suppressScaling ? child.radius / scale : child.radius

            var pp = CGPoint(x: child.position.r, y: 0)
            pp = pp.applying(CGAffineTransform(scaleX: scale, y: 0))
            pp = pp.applying(CGAffineTransform(rotationAngle: rotation))
            pp = pp.applying(CGAffineTransform(translationX: sprite.position.x, y: sprite.position.y))

            child.sprite.position = pp
            child.reify(scale: scale * childRadius)
        }
    }

    func showHide(_ show: Bool) { sprite.color = show ? color : .clear }

    func update(deltaTime: Double) {
        guard let radiusAnimator = radiusAnimator else { return }
        radiusAnimator.update(deltaTime: deltaTime / AppDefinitions.animationsDuration)
    }
}

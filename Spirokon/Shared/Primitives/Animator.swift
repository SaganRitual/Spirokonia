// We are a way for the cosmos to know itself. -- C. Sagan

import SpriteKit

class Animator {
    private let id = UUID()
    private let duration = 2.0
    private weak var sprite: SKSpriteNode!

    private var animatingValue: Double?
    private var endValue = 0.0
    private var startValue = 0.0

    var currentValue: Double {
        get { animatingValue ?? startValue }
        set { endValue = newValue; startValue = newValue; animatingValue = nil }
    }

    init(_ initialValue: Double, for sprite: SKSpriteNode) {
        startValue = initialValue
        endValue = initialValue
        self.sprite = sprite
    }

    func animate(to newValue: Double) {
        endValue = newValue

        if let aa = animatingValue {
            startValue = aa
            animatingValue = nil
        }

        let mainAction = SKAction.customAction(withDuration: duration) { [weak self] _, completion in
            guard let myself = self else { return }

            let c = myself.startValue +
                (completion / myself.duration) * (myself.endValue - myself.startValue)

            myself.animatingValue = c
        }

        mainAction.timingMode = SKActionTimingMode.easeInEaseOut

        let completionAction = SKAction.run { [weak self] in
            guard let myself = self else { return }
            myself.animatingValue = nil
            myself.startValue = myself.endValue
        }

        let sequence = SKAction.sequence([mainAction, completionAction])

        sprite.run(sequence, withKey: id.uuidString)
    }
}

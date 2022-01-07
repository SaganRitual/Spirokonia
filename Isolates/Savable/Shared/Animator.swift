// We are a way for the cosmos to know itself. -- C. Sagan

import Easing
import Foundation

class Animator<Owner: AnyObject> {
    private var animatingValue: ReferenceWritableKeyPath<Owner, Double>
    private weak var owner: Owner?

    private var duration: Double = 1.0
    private var elapsedTime: Double = 0.0
    private var startValue: Double = 0.0
    private var targetValue: Double = 0.0

    init(_ keyPath: ReferenceWritableKeyPath<Owner, Double>, for owner: Owner) {
        self.animatingValue = keyPath
        self.owner = owner
        self.startValue = owner[keyPath: keyPath]
        self.targetValue = self.startValue
    }

    func animate(to newValue: Double, duration: Double? = nil) {
        self.duration = duration ?? 1.0
        self.elapsedTime = 0.0
        self.startValue = owner![keyPath: animatingValue]
        self.targetValue = newValue
    }

    func update(deltaTime: Double) {
        if startValue == targetValue || elapsedTime >= duration {
            startValue = targetValue
            return
        }

        elapsedTime += deltaTime

        owner![keyPath: animatingValue] =
            startValue + Curve.quadratic.easeInOut(elapsedTime) / duration * (targetValue - startValue)
    }
}

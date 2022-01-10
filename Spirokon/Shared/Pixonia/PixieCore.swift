// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import SpriteKit

class PixieCore {
    let radiusAnimator: Animator<Supersprite>
    let sprite: Supersprite

    var radiusObserver: AnyCancellable!

    var skParent: SKNode { sprite.skParent }
    var ucParent: UCSpace { sprite.ucParent }

    var color: SKColor

    init(spritePool: SpritePool, color: SKColor, zIndex: Int, spaceName: String) {
        self.color = color
        self.sprite = .init(spritePool, color: color, zIndex: zIndex, spaceName: spaceName)
        self.radiusAnimator = Animator(\.radius, for: self.sprite)
    }

    func postInit(
        skParent: PixoniaScene, ucParent: UCSpace, radiusPublisher: Published<Double>.Publisher
    ) {
        sprite.postInit(skParent: skParent, ucParent: ucParent)

        radiusObserver =
            radiusPublisher.sink {
                [weak self] newRadius in guard let myself = self else { return }
                myself.radiusAnimator.animate(to: newRadius)
            }
    }
}

extension PixieCore {
    func showRing(_ show: Bool) {
        sprite.color = show ? color : .clear
    }
}

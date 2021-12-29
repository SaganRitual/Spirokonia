// We are a way for the cosmos to know itself. -- C. Sagan

import SpriteKit

class HotLabel {
    let labelNode = SKLabelNode()
    let text: String

    init(_ text: String) {
        self.text = text
    }

    func update(_ value: String) {
        labelNode.text = self.text + " " + value
    }
}

class PixieProxy {
    let skNode = SKNode()
    var labels = [HotLabel]()

    var verticalOffset = 0.0

    init(_ labels: [HotLabel]) {
        labels.forEach { [weak self] in self?.addLabel($0) }
    }

    func addLabel(_ label: HotLabel) {
        labels.append(label)
        skNode.addChild(label.labelNode)
        skNode.position.y = verticalOffset
        verticalOffset += label.labelNode.frame.size.height
    }
}

class MainControl {
    let pixieProxy: PixieProxy

    init() {
        pixieProxy = PixieProxy([
            HotLabel("Speed"), HotLabel("Density")
        ])
    }
}

class OuterRing {
    let ring: AppState.Ring
    let pixieProxy: PixieProxy

    init() {
        self.ring = .outerRing

        pixieProxy = PixieProxy([
            HotLabel("Roll mode"), HotLabel("Show ring"), HotLabel("Radius")
        ])
    }
}

class InnerRing {
    let ring: AppState.Ring
    let pixieProxy: PixieProxy

    init(_ ring: AppState.Ring) {
        self.ring = ring

        pixieProxy = PixieProxy([
            HotLabel("Roll mode"), HotLabel("Show ring"), HotLabel("Draw"),
            HotLabel("Radius"), HotLabel("Pen"), HotLabel("Color"), HotLabel("Decay")
        ])
    }
}

// We are a way for the cosmos to know itself. -- C. Sagan

import SpriteKit
import SwiftUI

class HotLabel: HotLabelProtocol {
    let labelNode = SKLabelNode()
    let labelText: String

    init(_ labelText: String) {
        self.labelNode.fontName = "Courier New"
        self.labelNode.fontSize *= 0.75
        self.labelText = labelText
    }

    func update(_ valueString: String) {
        labelNode.text = labelText + " " + valueString
    }
}

class PixieProxy: HasTumblerSettings {
    let skNode = SKNode()
    var labels = [HotLabel]()

    var verticalOffset = 0.0

    var tumblerSettings = TumblerSettings()

    init(_ labels: [HotLabel]) {
        labels.forEach { [weak self] in self?.addLabel($0) }
    }

    func addLabel(_ label: HotLabel) {
        labels.append(label)
        skNode.addChild(label.labelNode)
        label.labelNode.position.y = verticalOffset
        verticalOffset -= label.labelNode.frame.size.height * 2.0
    }
}

protocol HasUpdateFunction {
    func update()
}

class MainControl: HasUpdateFunction {
    let skNode = SKNode()
    let labels = [
        HotLabel("Speed"), HotLabel("Density")
    ]

    init() {
        skNode.position.x -= 200.0
        skNode.position.y += 400.0
    }

    update() {
        labels[0].update(pixieProxy.tumblerSettings.)
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

        pixieProxy.skNode.position.x += 200.0
        pixieProxy.skNode.position.y += 400.0
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

        switch ring {
        case .innerRing(let i): pixieProxy.skNode.position.x = -600.0 + Double(i) * 250.0
        default: fatalError()
        }

        pixieProxy.skNode.position.y += 100.0
    }
}

// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import SpriteKit
import SwiftUI

class PixoniaScene: SKScene, SKSceneDelegate, ObservableObject {
    @ObservedObject var appState: AppState

    var previousTime: TimeInterval?

    var pixie0 = SpritePool.plainRings.makeSprite()
    var pixie1 = SpritePool.spokeRings.makeSprite()
    var pixie2 = SpritePool.spokeRings.makeSprite()
    var pixie3 = SpritePool.spokeRings.makeSprite()

    var ratio1: Double = 2
    var ratio2: Double = 2
    var ratio3: Double = 2

    init(appState: ObservedObject<AppState>) {
        _appState = appState

        super.init(size: CGSize(width: 1024, height: 1024))

        self.anchorPoint = .anchorAtCenter
        self.scaleMode = .aspectFill
        self.backgroundColor = .black

        pixie0.color = SKColor(Color.random)
        pixie1.color = SKColor(Color.random)
        pixie2.color = SKColor(Color.random)
        pixie3.color = SKColor(Color.random)

        pixie0.size = self.size
        pixie1.size = self.size
        pixie2.size = self.size
        pixie3.size = self.size

        self.addChild(pixie0)
        pixie0.addChild(pixie1)
        pixie1.addChild(pixie2)
        pixie2.addChild(pixie3)

        pixie0.setScale(1.0)
        pixie1.setScale(1 / ratio1)
        pixie2.setScale(1 / ratio2)
        pixie3.setScale(1 / ratio3)
    }

    override func didMove(to view: SKView) {
        let baseTime: TimeInterval = 4.0

        let rollOuterRing = SKAction.rotate(byAngle: .tau, duration: baseTime / appState.cycleSpeed)
        let rollForever = SKAction.repeatForever(rollOuterRing)
        pixie0.run(rollForever, withKey: "roll-main-ring")
        pixie0.anchorPoint = .anchorAtCenter

        let rollPixie1 = SKAction.rotate(byAngle: -.tau, duration: baseTime / (appState.cycleSpeed * ratio1))
        let rollForever1 = SKAction.repeatForever(rollPixie1)
        pixie1.run(rollForever1, withKey: "roll-pixie-ring1")
        pixie1.anchorPoint = .anchorAtCenter

        let rollPixie2 = SKAction.rotate(byAngle: .tau, duration: baseTime / (appState.cycleSpeed * ratio1 * ratio2))
        let rollForever2 = SKAction.repeatForever(rollPixie2)
        pixie2.run(rollForever2, withKey: "roll-pixie-ring2")
        pixie2.anchorPoint = .anchorAtCenter

        let rollPixie3 = SKAction.rotate(byAngle: -.tau, duration: baseTime / (appState.cycleSpeed * ratio1 * ratio2 * ratio3))
        let rollForever3 = SKAction.repeatForever(rollPixie3)
        pixie3.run(rollForever3, withKey: "roll-pixie-ring3")
        pixie3.anchorPoint = .anchorAtCenter

        pixie0.position = CGPoint.zero
        pixie1.position = CGPoint(x: (pixie0.size.width - pixie1.size.width) / 2, y: 0)
        pixie2.position = CGPoint(x: (pixie0.size.width - pixie2.size.width) / 2, y: 0)
        pixie3.position = CGPoint(x: (pixie0.size.width - pixie3.size.width) / 2, y: 0)
    }

    override func update(_ currentTime: TimeInterval) {
        let duration: TimeInterval = 30.0
        defer { previousTime = currentTime }
//        guard let previousTime = previousTime else { return }

        let dot = SpritePool.dots.makeSprite()
        dot.size = CGSize(width: 5, height: 5)
        dot.color = .yellow
        dot.position = pixie1.convert(CGPoint(x: pixie0.size.width / 2, y: 0), to: self)
        self.addChild(dot)

        var fade = SKAction.fadeOut(withDuration: duration)
        dot.run(fade) {
            SpritePool.dots.releaseSprite(dot)
        }

        let gadot = SpritePool.dots.makeSprite()
        gadot.size = CGSize(width: 5, height: 5)
        gadot.color = .green
        gadot.position = pixie2.convert(CGPoint(x: pixie0.size.width / 2, y: 0), to: self)
        self.addChild(gadot)

        fade = SKAction.fadeOut(withDuration: duration)
        gadot.run(fade) {
            SpritePool.dots.releaseSprite(gadot)
        }

        let gal = SpritePool.dots.makeSprite()
        gal.size = CGSize(width: 5, height: 5)
        gal.color = .magenta
        gal.position = pixie3.convert(CGPoint(x: pixie0.size.width / 2, y: 0), to: self)
        self.addChild(gal)

        fade = SKAction.fadeOut(withDuration: duration)
        gal.run(fade) {
            SpritePool.dots.releaseSprite(gal)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import SpriteKit
import SwiftUI

class Connection {
    weak var pixie: Pixie?
    
}

class PixoniaScene: SKScene, SKSceneDelegate, ObservableObject {
    @ObservedObject var appState: AppState

    var isReady = false

    let radius: Double = 2048
    let sceneSpace: UCSpace

    var pixie1: Pixie!
    var pixie1PositionRObserver: AnyCancellable!
    var pixie1RadiusObserver: AnyCancellable!
    var pixie1RotationObserver: AnyCancellable!

    var pixie2: Pixie!
    var pixie2PositionRObserver: AnyCancellable!
    var pixie2RadiusObserver: AnyCancellable!
    var pixie2RotationObserver: AnyCancellable!

    var pixie3: Pixie!
    var pixie3PositionRObserver: AnyCancellable!
    var pixie3RadiusObserver: AnyCancellable!
    var pixie3RotationObserver: AnyCancellable!

    var pixie4: Pixie!
    var pixie4PositionRObserver: AnyCancellable!
    var pixie4RadiusObserver: AnyCancellable!
    var pixie4RotationObserver: AnyCancellable!

    var nibPositionRObserver: AnyCancellable!
    var penAxisObserver: AnyCancellable!

    init(appState: AppState) {
        _appState = ObservedObject(initialValue: appState)

        sceneSpace = UCSpace(radius: self.radius)
        super.init(size: sceneSpace.cgSize)

        self.anchorPoint = .anchorAtCenter
        self.scaleMode = .aspectFit
        self.backgroundColor = .black
    }

    override func didMove(to view: SKView) {
        pixie1 = Pixie(textureRadius: appState.texture1Radius, skParent: self, ucParent: sceneSpace)

        pixie1PositionRObserver = appState.$texture1PositionR.sink { [weak self] in
            guard let myself = self else { return }
            myself.pixie1.textureSpace.position.r = $0
        }

        pixie1RadiusObserver = appState.$texture1Radius.sink { [weak self] in
            guard let myself = self else { return }
            myself.pixie1.textureSpace.radius = $0
        }

        pixie1RotationObserver = appState.$texture1Rotation.sink { [weak self] in
            guard let myself = self else { return }
            myself.pixie1.textureSpace.rotation = $0
        }

        pixie2 = Pixie(
            textureRadius: appState.texture2Radius, skParent: self, ucParent: pixie1.textureSpace
        )

        pixie2PositionRObserver = appState.$texture2PositionR.sink { [weak self] in
            guard let myself = self else { return }
            myself.pixie2.textureSpace.position.r = $0
        }

        pixie2RadiusObserver = appState.$texture2Radius.sink { [weak self] in
            guard let myself = self else { return }
            myself.pixie2.textureSpace.radius = $0
        }

        pixie2RotationObserver = appState.$texture2Rotation.sink { [weak self] in
            guard let myself = self else { return }
            myself.pixie2.textureSpace.rotation = $0
        }

        pixie3 = Pixie(
            textureRadius: appState.texture3Radius, skParent: self, ucParent: pixie2.textureSpace
        )

        pixie3PositionRObserver = appState.$texture3PositionR.sink { [weak self] in
            guard let myself = self else { return }
            myself.pixie3.textureSpace.position.r = $0
        }

        pixie3RadiusObserver = appState.$texture3Radius.sink { [weak self] in
            guard let myself = self else { return }
            myself.pixie3.textureSpace.radius = $0
        }

        pixie3RotationObserver = appState.$texture3Rotation.sink { [weak self] in
            guard let myself = self else { return }
            myself.pixie3.textureSpace.rotation = $0
        }

        pixie4 = Pixie(
            textureRadius: appState.texture4Radius, skParent: self, ucParent: pixie3.textureSpace
        )

        pixie4PositionRObserver = appState.$texture4PositionR.sink { [weak self] in
            guard let myself = self else { return }
            myself.pixie4.textureSpace.position.r = $0
        }

        pixie4RadiusObserver = appState.$texture4Radius.sink { [weak self] in
            guard let myself = self else { return }
            myself.pixie4.textureSpace.radius = $0
        }

        pixie4RotationObserver = appState.$texture4Rotation.sink { [weak self] in
            guard let myself = self else { return }
            myself.pixie4.textureSpace.rotation = $0
        }

        pixie1.connect(to: [pixie2, pixie3, pixie4])
        pixie2.connect(to: [pixie3, pixie4, pixie1])
        pixie3.connect(to: [pixie4, pixie1, pixie2])
        pixie4.connect(to: [pixie1, pixie2, pixie3])

        nibPositionRObserver = appState.$nibPositionR.sink { [weak self] newR in
            guard let myself = self else { return }
            [myself.pixie1, myself.pixie2, myself.pixie3, myself.pixie4].forEach { pixie in
                pixie.connectors.forEach { connector in
                    connector.nib.space.position.r = newR
                }
            }
        }

        penAxisObserver = appState.$penAxis.sink { [weak self] newAxis in
            guard let myself = self else { return }

            [myself.pixie1, myself.pixie2, myself.pixie3, myself.pixie4].forEach { pixie in
                pixie.penAxis = newAxis
            }

            myself.isReady = true
        }
    }

    override func update(_ currentTime: TimeInterval) {
        guard isReady else { return }
        [pixie1, pixie2, pixie3, pixie4].forEach { $0.reify(to: sceneSpace) }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

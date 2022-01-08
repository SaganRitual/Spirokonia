// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct PreviewsObject {
    @StateObject var appModel: AppModel
    @StateObject var pixoniaScene: PixoniaScene

    init() {
        let state = AppModel()
        _appState = StateObject(wrappedValue: state)

        let scene = PixoniaScene(appModel: state)
        _pixoniaScene = StateObject(wrappedValue: scene)
    }
}

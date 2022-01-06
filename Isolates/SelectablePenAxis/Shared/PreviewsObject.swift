// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct PreviewsObject {
    @StateObject var appState: AppState
    @StateObject var pixoniaScene: PixoniaScene

    init() {
        let state = AppState()
        _appState = StateObject(wrappedValue: state)

        let scene = PixoniaScene(appState: state)
        _pixoniaScene = StateObject(wrappedValue: scene)
    }
}

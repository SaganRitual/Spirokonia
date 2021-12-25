// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct PixoniaAppView: View {
    @ObservedObject var appState: AppState
    @ObservedObject var pixoniaScene: PixoniaScene

    var body: some View {
        PixoniaView(appState: appState, scene: pixoniaScene)
    }
}

struct PixoniaAppView_Previews: PreviewProvider {
    static var appState = AppState()
    static var pixoniaScene = PixoniaScene(appState: ObservedObject(initialValue: appState))

    static var previews: some View {
        PixoniaAppView(appState: appState, pixoniaScene: pixoniaScene)
    }
}

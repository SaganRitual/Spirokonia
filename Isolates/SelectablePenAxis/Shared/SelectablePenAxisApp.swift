// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

class AppState: ObservableObject {
    @Published var texture1PositionR: Double = 0.0
    @Published var texture1Radius: Double = 0.5
    @Published var texture1Rotation: Double = 0.0

    @Published var texture2PositionR: Double = 0.0
    @Published var texture2Radius: Double = 0.5
    @Published var texture2Rotation: Double = 0.0

    @Published var texture3PositionR: Double = 0.0
    @Published var texture3Radius: Double = 0.5
    @Published var texture3Rotation: Double = 0.0

    @Published var texture4PositionR: Double = 0.0
    @Published var texture4Radius: Double = 0.5
    @Published var texture4Rotation: Double = 0.0

    @Published var nibPositionR: Double = 1.0
    @Published var penAxis: Int = 0
}

@main
struct SelectablePenAxisApp: App {
    @StateObject var appState: AppState
    @StateObject var pixoniaScene: PixoniaScene

    init() {
        let state = AppState()
        _appState = StateObject(wrappedValue: state)

        let scene = PixoniaScene(appState: state)
        _pixoniaScene = StateObject(wrappedValue: scene)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environmentObject(pixoniaScene)
        }
    }
}

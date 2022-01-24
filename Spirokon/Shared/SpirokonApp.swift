// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

@main
struct SpirokonApp: App {
    @State private var showWelcomeScreen = true
    @StateObject var appModel: AppModel
    @StateObject var pixoniaScene: PixoniaScene
    @StateObject var tumblerSelectorStateMachine: TumblerSelectorStateMachine

    #if os(iOS)
    @StateObject private var deviceOrientation = DeviceOrientation()
    #endif

    init() {
        let appModel = SpirokonApp.createAppModel()
        let sm = TumblerSelectorStateMachine(appModel: appModel)

        appModel.postInit(sm)

        let scene = PixoniaScene(appModel: appModel, tumblerSelectorStateMachine: sm)

        _appModel = StateObject(wrappedValue: appModel)
        _tumblerSelectorStateMachine = StateObject(wrappedValue: sm)
        _pixoniaScene = StateObject(wrappedValue: scene)

        if let loaded = UserDefaults.standard.data(forKey: "showWelcomeScreenAtStartup") {
            if let showWelcomeScreen = try? JSONDecoder().decode(Bool.self, from: loaded) {
                _showWelcomeScreen = State(initialValue: showWelcomeScreen)
            }
        }
    }

    static func createAppModel() -> AppModel {
        if let loaded = UserDefaults.standard.data(forKey: "LastSave") {
            do {
                return try JSONDecoder().decode(AppModel.self, from: loaded)
            } catch {
                print("Decode failed \(error)")
            }
        }

        return AppModel()
    }

    var body: some Scene {
        WindowGroup {
            ContentView(showWelcomeScreen: $showWelcomeScreen)
                .environmentObject(appModel)
                .environmentObject(pixoniaScene)
                .environmentObject(tumblerSelectorStateMachine)
                .environmentObject(deviceOrientation)
        }
    }
}

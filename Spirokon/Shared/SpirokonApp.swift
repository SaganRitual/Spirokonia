// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

@main
struct SpirokonApp: App {
    @StateObject var appModel: AppModel
    @StateObject var pixoniaScene: PixoniaScene
    @StateObject var tumblerSelectorStateMachine: TumblerSelectorStateMachine

    init() {
        let appModel = SpirokonApp.createAppModel()
        let sm = TumblerSelectorStateMachine(appModel: appModel)

        appModel.postInit(sm)

        let scene = PixoniaScene(appModel: appModel, tumblerSelectorStateMachine: sm)

        _appModel = StateObject(wrappedValue: appModel)
        _tumblerSelectorStateMachine = StateObject(wrappedValue: sm)
        _pixoniaScene = StateObject(wrappedValue: scene)
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
            ContentView()
                .environmentObject(appModel)
                .environmentObject(pixoniaScene)
                .environmentObject(tumblerSelectorStateMachine)
        }
    }
}

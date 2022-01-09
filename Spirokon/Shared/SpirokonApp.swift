// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

@main
struct SpirokonApp: App {
    @StateObject var appModel: AppModel
    @StateObject var pixoniaScene: PixoniaScene
    @StateObject var tumblerSelectorStateMachine: TumblerSelectorStateMachine

    init() {
        let appModel = SpirokonApp.createAppModel()

        print(
            "sh",
            appModel.drawingTumblerSettingsModels.tumblerSettingsModels[1].drawDots,
            appModel.drawingTumblerSettingsModels.tumblerSettingsModels[1].showRing
        )

        let sm = TumblerSelectorStateMachine(appModel: appModel)

        appModel.postInit(sm)

        print(
            "sh2",
            appModel.drawingTumblerSettingsModels.tumblerSettingsModels[1].drawDots,
            appModel.drawingTumblerSettingsModels.tumblerSettingsModels[1].showRing
        )

        let scene = PixoniaScene(appModel: appModel, tumblerSelectorStateMachine: sm)

        _appModel = StateObject(wrappedValue: appModel)
        _tumblerSelectorStateMachine = StateObject(wrappedValue: sm)
        _pixoniaScene = StateObject(wrappedValue: scene)
    }

    static func createAppModel() -> AppModel {
        if let loaded = UserDefaults.standard.data(forKey: "LastSave") {
            print("Loaded from LastSave", String(data: loaded, encoding: .utf8)!)

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

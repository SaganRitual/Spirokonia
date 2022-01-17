// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

@main
struct SpirokonApp: App {
    @StateObject var appModel: AppModel
    @StateObject var pixoniaScene: PixoniaScene
    @StateObject var tumblerSelectorStateMachine: TumblerSelectorStateMachine

    @StateObject private var deviceOrientation = DeviceOrientation()

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
            Group {
                if UIDevice.current.userInterfaceIdiom == .phone {
                    if deviceOrientation.orientation == .landscape {
                        ContentView_HPhone()
                    } else {
                        ContentView_VPhone()
                    }
                } else {
                    ContentView()
                }
            }

            .environmentObject(appModel)
            .environmentObject(pixoniaScene)
            .environmentObject(tumblerSelectorStateMachine)
        }
    }
}

// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appModel: AppModel
    @EnvironmentObject var pixoniaScene: PixoniaScene

    var landscape = false

    var body: some View {
        NavigationView {
            Form {
                Section("Main") {
                    TumblerSettingsViewOuter()
                }

                Section("Tumblers") {
                    TumblerSelectorView()
                    TumblerSettingsViewInner()
                }

                Section("Save / Load") {
                    SaveLoad()
                }

                NavigationLink("Quick Help") {
                    HelpView()
                }
            }
            .navigationTitle("Dashboard")

            PixoniaView(scene: pixoniaScene)
        }
    }
}

struct Previews_ContentView_Previews: PreviewProvider {
    struct Objects {
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
    }

    static let objects = Objects()

    static var previews: some View {
        ContentView()
            .environmentObject(objects.appModel)
            .environmentObject(objects.pixoniaScene)
    }
}

// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

@main
struct SavableApp: App {
    @StateObject var appModel: AppModel
    @StateObject var tumblerSelectorStateMachine: TumblerSelectorStateMachine

    init() {
        let appModel = AppModel()
        let sm = TumblerSelectorStateMachine(appModel: appModel)

        appModel.postInit(sm)

        _appModel = StateObject(wrappedValue: appModel)
        _tumblerSelectorStateMachine = StateObject(wrappedValue: sm)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appModel)
                .environmentObject(tumblerSelectorStateMachine)
        }
    }
}

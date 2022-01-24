// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct RunView_HBig: View {
    @EnvironmentObject var appModel: AppModel
    @EnvironmentObject var pixoniaScene: PixoniaScene

    @State private var showQuickHelp = false

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

                Section {
                    Button(
                        action: { withAnimation { showQuickHelp.toggle() } },
                        label: { Text(showQuickHelp ? "Return to SpiroZen" : "Quick Help") }
                    )

                    Link(
                        destination: URL(string: "https://saganritual.github.io/spirozen-classic-getting-started/")!,
                        label: { Text("Watch 'Getting Started with SpiroZen' online") }
                    )
                }
            }
            .navigationTitle("Dashboard")

            if showQuickHelp {
                HelpView().transition(.move(edge: .trailing))
            } else {
                PixoniaView(scene: pixoniaScene)
            }
        }
    }
}

struct Previews_RunView_Previews: PreviewProvider {
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
        RunView()
            .environmentObject(objects.appModel)
            .environmentObject(objects.pixoniaScene)
    }
}

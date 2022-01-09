// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

class TumblerSettingsModels: ObservableObject, Codable {
    @Published var tumblerSettingsModels = [TumblerSettingsModel]()

    enum CodingKeys: CodingKey {
        case tumblerSettingsModels
    }

    var appModel: AppModel!
    var tumblerSelectorStateMachine: TumblerSelectorStateMachine!

    init() { }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        tumblerSettingsModels =
            try container.decode([TumblerSettingsModel].self, forKey: .tumblerSettingsModels)
    }

    func postInit1(_ appModel: AppModel, _ tumblerSelectorStateMachine: TumblerSelectorStateMachine) {
        if appModel.decoded { return }
        tumblerSettingsModels = (0..<4).map { _ in TumblerSettingsModel() }
    }

    func postInit2(_ appModel: AppModel, _ tumblerSelectorStateMachine: TumblerSelectorStateMachine) {
        if appModel.decoded { return }
        tumblerSettingsModels.forEach { $0.postInit(appModel, tumblerSelectorStateMachine)}
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(tumblerSettingsModels, forKey: .tumblerSettingsModels)
    }

    func copy(from loaded: TumblerSettingsModels) {
        tumblerSettingsModels = loaded.tumblerSettingsModels
    }
}

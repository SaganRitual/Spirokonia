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

    func postInit(_ appModel: AppModel, _ tumblerSelectorStateMachine: TumblerSelectorStateMachine) {
        tumblerSettingsModels = (0..<4).map { _ in
            let m = TumblerSettingsModel()
            m.postInit(appModel, tumblerSelectorStateMachine)
            return m
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(tumblerSettingsModels, forKey: .tumblerSettingsModels)
    }

    func copy(from loaded: TumblerSettingsModels) {
        for (dest, source) in zip(tumblerSettingsModels, loaded.tumblerSettingsModels) {
            dest.copy(from: source)
        }
    }

    func copy(to toBeSaved: TumblerSettingsModels) {
        for (dest, source) in zip(toBeSaved.tumblerSettingsModels, tumblerSettingsModels) {
            source.copy(to: dest)
        }
    }
}

// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import SwiftUI

class AppModel: ObservableObject, Codable {
    let decoded: Bool

    @Published var cycleSpeed: Double = 0.1
    @Published var density: Double = 5
    @Published var outerRingRadius: Double = 1.0
    @Published var outerRingRollMode = AppDefinitions.RollMode.normal
    @Published var outerRingShow = true

    @Published var tumblerSelectorSwitches: [AppDefinitions.TumblerSelectorSwitchState] = [
        .trueDefinite, .falseDefinite, .falseDefinite, .falseDefinite
    ]

    @Published var masterSettingsModel = TumblerSettingsModel()
    @Published var drawingTumblerSettingsModels = TumblerSettingsModels()

    @Published var cycleSpeedStepKey: Int = 2
    @Published var densityStepKey: Int = 2
    @Published var outerRingRadiusStepKey: Int = 2

    var reZero = PassthroughSubject<Void, Never>()

    enum CodingKeys: CodingKey {
        case animationsDuration, cycleSpeed, density
        case outerRingRadius, outerRingRollMode, outerRingShow
        case tumblerSelectorSwitches
        case cycleSpeedStepKey, densityStepKey, outerRingRadiusStepKey
        case masterSettingsModel, drawingTumblerSettingsModels
    }

    init() { self.decoded = false }

    func postInit(_ tumblerSelectorStateMachine: TumblerSelectorStateMachine) {
        drawingTumblerSettingsModels.postInit1(self, tumblerSelectorStateMachine)
        drawingTumblerSettingsModels.postInit2(self, tumblerSelectorStateMachine)
        masterSettingsModel.postInit(self, tumblerSelectorStateMachine)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        cycleSpeed = try container.decode(Double.self, forKey: .cycleSpeed)
        density = try container.decode(Double.self, forKey: .density)
        outerRingRadius = try container.decode(Double.self, forKey: .outerRingRadius)
        outerRingRollMode = try container.decode(AppDefinitions.RollMode.self, forKey: .outerRingRollMode)
        outerRingShow = try container.decode(Bool.self, forKey: .outerRingShow)

        tumblerSelectorSwitches = try container.decode([AppDefinitions.TumblerSelectorSwitchState].self, forKey: .tumblerSelectorSwitches)

        cycleSpeedStepKey = try container.decode(Int.self, forKey: .cycleSpeedStepKey)
        outerRingRadiusStepKey = try container.decode(Int.self, forKey: .outerRingRadiusStepKey)
        densityStepKey = try container.decode(Int.self, forKey: .densityStepKey)

        masterSettingsModel = try container.decode(TumblerSettingsModel.self, forKey: .masterSettingsModel)
        drawingTumblerSettingsModels = try container.decode(TumblerSettingsModels.self, forKey: .drawingTumblerSettingsModels)

        self.decoded = true
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cycleSpeed, forKey: .cycleSpeed)
        try container.encode(density, forKey: .density)
        try container.encode(outerRingRadius, forKey: .outerRingRadius)
        try container.encode(outerRingRollMode, forKey: .outerRingRollMode)
        try container.encode(outerRingShow, forKey: .outerRingShow)

        try container.encode(tumblerSelectorSwitches, forKey: .tumblerSelectorSwitches)

        try container.encode(cycleSpeedStepKey, forKey: .cycleSpeedStepKey)
        try container.encode(outerRingRadiusStepKey, forKey: .outerRingRadiusStepKey)
        try container.encode(densityStepKey, forKey: .densityStepKey)

        try container.encode(masterSettingsModel, forKey: .masterSettingsModel)
        try container.encode(drawingTumblerSettingsModels, forKey: .drawingTumblerSettingsModels)
    }

    func copy(from loaded: AppModel) {
        self.cycleSpeed = loaded.cycleSpeed
        self.density = loaded.density
        self.outerRingRadius = loaded.outerRingRadius
        self.outerRingRollMode = loaded.outerRingRollMode
        self.outerRingShow = loaded.outerRingShow

        self.tumblerSelectorSwitches = loaded.tumblerSelectorSwitches

        self.cycleSpeedStepKey = loaded.cycleSpeedStepKey
        self.outerRingRadiusStepKey = loaded.outerRingRadiusStepKey
        self.densityStepKey = loaded.densityStepKey

        self.masterSettingsModel.copy(from: loaded.masterSettingsModel)
        self.drawingTumblerSettingsModels.copy(from: loaded.drawingTumblerSettingsModels)
    }
}

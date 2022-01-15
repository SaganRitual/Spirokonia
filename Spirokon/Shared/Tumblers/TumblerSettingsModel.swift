// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

class TumblerSettingsModel: ObservableObject, Codable {
    @Published var colorSpeed: Double = 0.1
    @Published var drawDots = true
    @Published var penAxis: Int = 0
    @Published var pen: Double = 1.0
    @Published var radius: Double = 0.5
    @Published var rollMode = AppDefinitions.RollMode.cycloid
    @Published var rollRelationship = AppDefinitions.RollRelationship.innerToInner
    @Published var showRing = true
    @Published var trailDecay: Double = 3

    @Published var colorSpeedStepKey: Int = 0
    @Published var penStepKey: Int = 2
    @Published var radiusStepKey: Int = 2
    @Published var trailDecayStepKey: Int = 0

    var appModel: AppModel!
    var observers: TumblerSettingsObservers!
    var tumblerSelectorStateMachine: TumblerSelectorStateMachine!

    enum CodingKeys: CodingKey {
        case colorSpeed, drawDots, pen, penAxis, radius, rollMode, rollRelationship
        case showRing, trailDecay
        case colorSpeedStep, penStep, radiusStep, trailDecayStep
    }

    init() {}

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        colorSpeed = try container.decode(Double.self, forKey: .colorSpeed)
        drawDots = try container.decode(Bool.self, forKey: .drawDots)
        pen = try container.decode(Double.self, forKey: .pen)
        penAxis = try container.decode(Int.self, forKey: .penAxis)
        radius = try container.decode(Double.self, forKey: .radius)
        rollMode = try container.decode(AppDefinitions.RollMode.self, forKey: .rollMode)
        rollRelationship = try container.decode(AppDefinitions.RollRelationship.self, forKey: .rollRelationship)
        showRing = try container.decode(Bool.self, forKey: .showRing)
        trailDecay = try container.decode(Double.self, forKey: .trailDecay)

        colorSpeedStepKey = try container.decode(Int.self, forKey: .colorSpeedStep)
        penStepKey = try container.decode(Int.self, forKey: .penStep)
        radiusStepKey = try container.decode(Int.self, forKey: .radiusStep)
        trailDecayStepKey = try container.decode(Int.self, forKey: .trailDecayStep)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(colorSpeed, forKey: .colorSpeed)
        try container.encode(drawDots, forKey: .drawDots)
        try container.encode(pen, forKey: .pen)
        try container.encode(penAxis, forKey: .penAxis)
        try container.encode(radius, forKey: .radius)
        try container.encode(rollMode, forKey: .rollMode)
        try container.encode(rollRelationship, forKey: .rollRelationship)
        try container.encode(showRing, forKey: .showRing)
        try container.encode(trailDecay, forKey: .trailDecay)

        try container.encode(colorSpeedStepKey, forKey: .colorSpeedStep)
        try container.encode(penStepKey, forKey: .penStep)
        try container.encode(radiusStepKey, forKey: .radiusStep)
        try container.encode(trailDecayStepKey, forKey: .trailDecayStep)
    }

    func postInit(
        _ appModel: AppModel, _ tumblerSelectorStateMachine: TumblerSelectorStateMachine
    ) {
        observers = .init(appModel, tumblerSelectorStateMachine)
        observers.postInit()
    }

    func copy(from loaded: TumblerSettingsModel) {
        self.colorSpeed = loaded.colorSpeed
        self.drawDots = loaded.drawDots
        self.pen = loaded.pen
        self.penAxis = loaded.penAxis
        self.radius = loaded.radius
        self.rollMode = loaded.rollMode
        self.rollRelationship = loaded.rollRelationship
        self.showRing = loaded.showRing
        self.trailDecay = loaded.trailDecay

        self.colorSpeedStepKey = loaded.colorSpeedStepKey
        self.penStepKey = loaded.penStepKey
        self.radiusStepKey = loaded.radiusStepKey
        self.trailDecayStepKey = loaded.trailDecayStepKey
    }

    func copy(to toBeSaved: TumblerSettingsModel) {
        toBeSaved.colorSpeed = self.colorSpeed
        toBeSaved.drawDots = self.drawDots
        toBeSaved.pen = self.pen
        toBeSaved.penAxis = self.penAxis
        toBeSaved.radius = self.radius
        toBeSaved.rollMode = self.rollMode
        toBeSaved.rollRelationship = self.rollRelationship
        toBeSaved.showRing = self.showRing
        toBeSaved.trailDecay = self.trailDecay

        toBeSaved.colorSpeedStepKey = self.colorSpeedStepKey
        toBeSaved.penStepKey = self.penStepKey
        toBeSaved.radiusStepKey = self.radiusStepKey
        toBeSaved.trailDecayStepKey = self.trailDecayStepKey
    }
}

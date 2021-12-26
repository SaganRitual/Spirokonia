// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

class AppState: ObservableObject {
    enum RollMode {
        case compensate, doesNotRoll, fullStop, normal
    }

    enum Ring {
        case innerRing(Int), outerRing
    }

    enum ToggleType {
        case drawDots, showRing
    }

    @Published var drawDotsInner = true
    @Published var drawDotsOuter = true
    @Published var showRingInner = true
    @Published var showRingOuter = true

    @Published var innerRingRollMode = RollMode.normal
    @Published var outerRingRollMode = RollMode.normal

    @Published var cycleSpeed = 1.0
    @Published var outerRingRadius = 1.0

    @Published var colorSpeed = 1.0
    @Published var density = 1.0
    @Published var pen = 0.5
    @Published var radius = 1.0
    @Published var trailDecay = 1.0

    @Published var tumblerSelectorSwitches = [Bool](repeating: true, count: 4)

    static let colorSpeedRange = 0.0...2.0
    static let cycleSpeedRange = 0.0...1.0
    static let dotDensityRange = 0.0...30.0
    static let trailDecayRange = 0.0...60.0
    static let unitRange = 0.0...1.0

    static let showTextLabels = false
}

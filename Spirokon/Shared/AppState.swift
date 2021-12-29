// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

class AppState: ObservableObject {
    enum RollMode {
        case compensate, doesNotRoll, fullStop, normal
    }

    enum Ring {
        case innerRing(Int), outerRing

        func isInnerRing(_ ix: Int? = nil) -> Bool {
            switch self {
            case .outerRing: return false
            case .innerRing(let irix): return ix == nil ? true : irix == ix!
            }
        }
    }

    enum ToggleType {
        case drawDots, showRing
    }

    @Published var drawDotsInner = true
    @Published var showRingInner = true
    @Published var showRingOuter = true

    @Published var innerRingRollMode = RollMode.normal
    @Published var outerRingRollMode = RollMode.normal

    @Published var cycleSpeed: Double = 0.5
    @Published var outerRingRadius: Double = 1.0

    @Published var colorSpeed: Double = 0.05
    @Published var density: Double = 5
    @Published var pen: Double = 1.0
    @Published var radius: Double = 1.0 - (1.0 / 10.0)
    @Published var trailDecay: Double = 10

    enum TumblerSelectorSwitchState {
        case trueDefinite, trueIndefinite, falseDefinite, falseIndefinite

        var isTracking: Bool { if case .trueDefinite = self { return true } else { return false } }

        var isDefinite: Bool {
            switch self {
            case .falseIndefinite: fallthrough
            case .trueIndefinite:  return false

            case .falseDefinite: fallthrough
            case .trueDefinite:  return true
            }
        }
    }

    @Published var tumblerSelectorSwitches = [TumblerSelectorSwitchState](repeating: .trueDefinite, count: 4)

    static let colorSpeedRange = 0.0...1.0
    static let cycleSpeedRange = 0.0...2.0
    static let dotDensityRange = 0.0...20.0
    static let trailDecayRange = 0.0...20.0
    static let unitRange = 0.0...1.0

    static let showTextLabels = true
}

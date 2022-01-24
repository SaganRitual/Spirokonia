// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

enum AppDefinitions {
    enum RollMode: Codable {
        case compensate, cycloid, doesNotRoll, fullStop, sticky, flattened
    }

    enum RollRelationship: Codable {
        case innerToInner, outerToOuter
    }

    enum Ring {
        case innerRing(Int), outerRing

        func isInnerRing(_ ix: Int? = nil) -> Bool {
            switch self {
            case .outerRing: return false
            case .innerRing(let irix): return ix == nil ? true : irix == ix!
            }
        }

        func isOuterRing() -> Bool { !isInnerRing() }

        var ix: Int {
            switch self {
            case .outerRing: return 0
            case .innerRing(let r): return r
            }
        }
    }

    enum ToggleType {
        case drawDots, showRing
    }

    enum TumblerSelectorSwitchState: Codable {
        case trueDefinite, trueIndefinite, falseDefinite, falseIndefinite

        var isEngaged: Bool { if case .trueDefinite = self { return true } else { return false } }

        var isDefinite: Bool {
            switch self {
            case .falseIndefinite: fallthrough
            case .trueIndefinite:  return false

            case .falseDefinite: fallthrough
            case .trueDefinite:  return true
            }
        }
    }

    static let animationsDuration = 5.0
    static let platterPixieColor = Color.crownpurple
    static let drawingPixieColors: [Color] = [
        .velvetpresley, .shizzabrick, .yellowShizzabrickRoad, .greenWithMayo
    ]

    static let colorSpeedRange = 0.0...1.0
    static let cycleSpeedRange = 0.0...2.0
    static let dotDensityRange = 1.0...50.0
    static let trailDecayRange = 0.0...20.0
    static let unitRange = 0.0...2.0

    static let showTextLabels = false

    static var versionString: String {
        (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String)!
    }
}

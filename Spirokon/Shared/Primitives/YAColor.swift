// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

#if os(macOS)
typealias YAColor = NSColor
#elseif os(iOS)
import UIKit
typealias YAColor = UIColor
#endif

extension Color {
    public static let crownpurple = Color(#colorLiteral(red: 0.2029999942, green: 0.1280000061, blue: 0.5730000138, alpha: 1))
    public static let pixieborder = Color(#colorLiteral(red: 0, green: 1, blue: 0.6499999762, alpha: 1))
    public static let pixiefill = Color(#colorLiteral(red: 0, green: 0.6848070894, blue: 0.4451245918, alpha: 1))
    public static let indefiniteButtonPress = Color(#colorLiteral(red: 0.40591746, green: 0.4063741724, blue: 0.4199178773, alpha: 1))
    public static let salmonzilla = Color(#colorLiteral(red: 1, green: 0.5799999833, blue: 0.7059999704, alpha: 1))
    public static let shizzabrick = Color(#colorLiteral(red: 0.5989899137, green: 0.2336060577, blue: 0.1078181888, alpha: 1))
    public static let tealjeans = Color(#colorLiteral(red: 0.4690000117, green: 0.8590000272, blue: 0.449000001, alpha: 1))
    public static let velvetpresley = Color(#colorLiteral(red: 0.349999994, green: 0.1280000061, blue: 0.5730000138, alpha: 1))

    public static var random: Color {
        Color(YAColor(hue: Double.random(in: 0...1), saturation: 1, brightness: 1, alpha: 1))
    }
}

extension YAColor {
    enum Scale: CaseIterable {
        case red, green, blue, rgbAlpha, hue, saturation, brightness, hsbAlpha
    }

    static func css(_ code: String) -> YAColor {
        precondition(code.first! == "#")
        let r = Double(Int(code.substr(1..<3), radix: 16)!) / 256.0
        let g = Double(Int(code.substr(3..<5), radix: 16)!) / 256.0
        let b = Double(Int(code.substr(5..<7), radix: 16)!) / 256.0
        return YAColor(red: r, green: g, blue: b, alpha: 1)
    }

    func rotateHue(byAngle radians: Double) -> YAColor {
        var h = CGFloat.zero, s = CGFloat.zero, b = CGFloat.zero, a = CGFloat.zero
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)

        h = (h + (radians / .tau)).truncatingRemainder(dividingBy: 1.0)

        #if os(macOS)
        return NSColor(calibratedHue: h, saturation: s, brightness: b, alpha: a)
        #elseif os(iOS)
        return UIColor(hue: h, saturation: s, brightness: b, alpha: a)
        #endif
    }

    func scale(_ component: Scale, by scaleFactor: Double) -> YAColor {
        if [Scale.red, .green, .blue, .rgbAlpha].contains(component) {
            return scaleRGBA(component, by: scaleFactor)
        } else {
            return scaleHSBA(component, by: scaleFactor)
        }
    }

    private func scaleRGBA(_ component: Scale, by scaleFactor: Double) -> YAColor {
        var r = CGFloat.zero, g = CGFloat.zero, b = CGFloat.zero, a = CGFloat.zero
        self.getRed(&r, green: &g, blue: &b, alpha: &a)

        switch component {
        case .red:      r *= scaleFactor
        case .green:    g *= scaleFactor
        case .blue:     b *= scaleFactor
        case .rgbAlpha: a *= scaleFactor
        default: fatalError()
        }

        #if os(macOS)
        return NSColor(calibratedRed: r, green: g, blue: b, alpha: a)
        #elseif os(iOS)
        return UIColor(red: r, green: g, blue: b, alpha: a)
        #endif
    }

    func red(_ scaleFactor: Double) -> YAColor { scale(.red, by: scaleFactor) }
    func green(_ scaleFactor: Double) -> YAColor { scale(.green, by: scaleFactor) }
    func blue(_ scaleFactor: Double) -> YAColor { scale(.blue, by: scaleFactor) }
    func rgbAlpha(_ scaleFactor: Double) -> YAColor { scale(.rgbAlpha, by: scaleFactor) }

    private func scaleHSBA(_ component: Scale, by scaleFactor: Double) -> YAColor {
        var h = CGFloat.zero, s = CGFloat.zero, b = CGFloat.zero, a = CGFloat.zero
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)

        switch component {
        case .hue:        h *= scaleFactor
        case .saturation: s *= scaleFactor
        case .brightness: b *= scaleFactor
        case .hsbAlpha:   a *= scaleFactor
        default: fatalError()
        }

        #if os(macOS)
        return NSColor(calibratedHue: h, saturation: s, brightness: b, alpha: a)
        #elseif os(iOS)
        return UIColor(hue: h, saturation: s, brightness: b, alpha: a)
        #endif
    }
}

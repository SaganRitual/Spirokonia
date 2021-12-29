// We are a way for the cosmos to know itself. -- C. Sagan

import CoreGraphics
import Foundation

struct UCPoint {
    var r = 0.0
    var t = 0.0

    // Totally feels like cheating; learn how to do all this without xy
    var x: Double { r * cos(t) }
    var y: Double { r * sin(t) }

    // Although this is necessary for talking to SpriteKit
    var cgPoint: CGPoint { CGPoint(x: x, y: y) }

    static var zero: UCPoint { UCPoint(r: 0.0, t: 0.0) }

    init(r: Double, t: Double) { self.r = r; self.t = t }
    init(x: Double, y: Double) { self.r = sqrt(x * x + y * y); self.t = atan2(y, x) }
    init(_ cgPoint: CGPoint)   { self.init(x: cgPoint.x, y: cgPoint.y) }

    func rotated(by radians: Double) -> UCPoint {
        UCPoint(self.cgPoint.applying(CGAffineTransform(rotationAngle: radians)))
    }

    func scaled(toRadius: Double) -> UCPoint {
        UCPoint(self.cgPoint.applying(CGAffineTransform(scaleX: toRadius, y: toRadius)))
    }

    func translated(by delta: UCPoint) -> UCPoint {
        UCPoint(self.cgPoint.applying(CGAffineTransform(translationX: delta.x, y: delta.y)))
    }

    static func * (_ lhs: UCPoint, _ rhs: UCPoint) -> UCPoint {
        UCPoint(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
    }

    static func * (_ lhs: UCPoint, _ rhs: UCSize) -> UCPoint {
        UCPoint(x: lhs.x * rhs.width, y: lhs.y * rhs.height)
    }

    static func * (_ lhs: UCPoint, _ rhs: Double) -> UCPoint {
        UCPoint(x: lhs.x * rhs, y: lhs.y * rhs)
    }

    static func *= (_ lhs: inout UCPoint, _ rhs: UCPoint) { lhs = lhs * rhs }

    static func *= (_ lhs: inout UCPoint, _ rhs: Double) { lhs = lhs * rhs }
}

func zeroish(_ v: Double, decimals: Int = 4, fixedWidth: Int? = nil) -> String {
    abs(v) < pow(10, -Double(decimals + 1)) ? "<0>" : "\(v.asString(decimals: decimals, fixedWidth: fixedWidth))"
}

extension UCPoint: CustomDebugStringConvertible {
    var debugDescription: String { "UCPoint(r: \(zeroish(r)), t: \(zeroish(t)))" }
}

extension UCPoint: Hashable {
    static func == (lhs: UCPoint, rhs: UCPoint) -> Bool {
        lhs.r == rhs.r && lhs.t == rhs.t
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(r)
        hasher.combine(t)
    }
}

struct UCSize {
    var width: Double
    var height: Double

    var cgSize: CGSize { CGSize(width: width, height: height) }

    static let unit: UCSize = UCSize(width: 2.0, height: 2.0)

    static func * (_ lhs: UCSize, _ rhs: UCSize) -> UCSize {
        UCSize(width: lhs.width * rhs.width, height: lhs.height * rhs.height)
    }

    static func * (_ lhs: UCSize, _ rhs: Double) -> UCSize {
        UCSize(width: lhs.width * rhs, height: lhs.height * rhs)
    }

    static func *= (_ lhs: inout UCSize, _ rhs: UCSize) { lhs = lhs * rhs }

    static func *= (_ lhs: inout UCSize, _ rhs: Double) { lhs = lhs * rhs }
}

class UCWorld {
    var theWorldSpace = UCSpace()
    let size: UCSize

    init(width: Double, height: Double) {
        self.size = UCSize(width: width, height: height)
    }

    func emplace(_ space: UCSpace) -> UCPoint {
        var pp = space.position
        var sp = space

        var firstPass = true
        while let parent = sp.parent {
            if firstPass {
                firstPass = false
            } else {
                pp = pp.scaled(toRadius: sp.radius)
                pp = pp.rotated(by: sp.rotation)
                pp = pp.translated(by: sp.position)
            }
            sp = parent
        }

        return pp * (self.size.width / 2.0)
    }

    func emroll(_ space: UCSpace) -> Double {
        var sp = space
        var zr = 0.0

        while let parent = sp.parent {
            zr += sp.rotation
            sp = parent
        }

        return zr
    }

    func ensize(_ space: UCSpace) -> UCSize {
        var sz = self.size * space.radius
        var sp = space

        while let parent = sp.parent {
            sz *= parent.radius
            sp = parent
        }

        return sz
    }
}

class UCSpace {
    var anchorPoint = UCPoint.zero
    var position = UCPoint.zero
    var radius = 1.0
    var rotation = 0.0

    var children = [UCSpace]()
    weak var parent: UCSpace?

    static var unit: UCSpace { UCSpace(radius: 1.0, rotation: 0.0) }

    var diameter: Double { 2 * radius }

    init(anchorPoint: UCPoint = .zero, position: UCPoint = .zero, radius: Double = 1.0, rotation: Double = 0.0) {
        self.anchorPoint = anchorPoint
        self.position = position
        self.radius = radius
        self.rotation = rotation
    }

    func addChild(_ space: UCSpace) {
        precondition(space.parent == nil, "Can't add this child; it already has a parent")
        space.parent = self
        children.append(space)
    }

    func removeChild(_ space: UCSpace) -> UCSpace? {
        guard let ix = children.firstIndex(where: { $0 === space }) else { return nil }
        let child = children.remove(at: ix)
        child.parent = nil
        return child
    }
}

extension UCSpace: CustomDebugStringConvertible {
    var debugDescription: String {
        "UCSpace(radius: \(zeroish(radius)), rotation: \(zeroish(rotation))) position \(position) anchor \(anchorPoint)"
    }
}

extension UCSpace: Hashable {
    static func == (_ lhs: UCSpace, _ rhs: UCSpace) -> Bool { lhs === rhs }

    func hash(into hasher: inout Hasher) {
        hasher.combine(radius)
        hasher.combine(rotation)
    }
}

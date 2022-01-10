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

    public func distance(to otherPoint: UCPoint) -> Double {
        let dx = x - otherPoint.x
        let dy = y - otherPoint.y
        return sqrt(dx * dx + dy * dy)
    }

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
/*
    static func * (_ lhs: UCPoint, _ rhs: UCSize) -> UCPoint {
        UCPoint(x: lhs.x * rhs.width, y: lhs.y * rhs.height)
    }
*/
    static func * (_ lhs: UCPoint, _ rhs: Double) -> UCPoint {
        UCPoint(x: lhs.x * rhs, y: lhs.y * rhs)
    }

    static func - (_ lhs: UCPoint, _ rhs: UCPoint) -> UCPoint {
        UCPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
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
    var radius: Double

    var width: Double  { radius * 2.0 }
    var height: Double { radius * 2.0 }

    var cgSize: CGSize { CGSize(width: width, height: height) }

    static var unit: UCSize { UCSize(radius: 1.0) }

    static func * (_ lhs: UCSize, _ rhs: UCSize) -> UCSize {
        UCSize(radius: lhs.radius * rhs.radius)
    }

    static func * (_ lhs: UCSize, _ rhs: Double) -> UCSize {
        UCSize(radius: lhs.radius * rhs)
    }

    static func *= (_ lhs: inout UCSize, _ rhs: UCSize) { lhs = lhs * rhs }

    static func *= (_ lhs: inout UCSize, _ rhs: Double) { lhs = lhs * rhs }
}

class UCSpace {
    let name: String
    var anchorPoint = UCPoint.zero
    var position = UCPoint.zero
    var radius = 1.0
    var rotation = 0.0

    var children = [UCSpace]()
    weak var parent: UCSpace?

    static var unit: UCSpace { UCSpace(name: "Generic unit space", radius: 1.0, rotation: 0.0) }

    var cgSize: CGSize { CGSize(width: diameter, height: diameter) }
    var diameter: Double { 2 * radius }

    init(
        name: String, anchorPoint: UCPoint = .zero, position: UCPoint = .zero,
        radius: Double = 1.0, rotation: Double = 0.0
    ) {
        self.name = name
        self.anchorPoint = anchorPoint
        self.position = position
        self.radius = radius
        self.rotation = rotation
    }
}

extension UCSpace {
    /// Get position of my descendant `space` in my terms
    /// - Parameter space: the descendant whose position we want
    /// - Returns: position of `space` scaled to me
    func emplace(_ space: UCSpace) -> UCPoint {
        var pp = space.position
        var sp = space

        var firstPass = true
        while let parent = sp.parent {
            defer {
                sp = parent
                firstPass = false
            }

            if firstPass { continue }

            pp = pp.scaled(toRadius: sp.radius)
            pp = pp.rotated(by: sp.rotation)
            pp = pp.translated(by: sp.position)
        }

        pp = pp.scaled(toRadius: self.radius)
        pp = pp.rotated(by: self.rotation)
        pp = pp.translated(by: self.position)
        return pp
    }

    // For accumulating all the absolute rotations in the lineage
    func emroll(_ space: UCSpace) -> Double {
        var sp = space
        var zr = 0.0

        while let parent = sp.parent {
            zr += sp.rotation
            sp = parent
        }

        return zr
    }

    // For calculating a rotation delta
    func emroll(_ rotation: Double, space: UCSpace) -> Double {
        var sp = space
        var zr = rotation / space.radius

        while let parent = sp.parent, parent !== self {
            zr /= parent.radius
            sp = parent
        }

        return zr
    }

    /// Get size of my descendant `space` in my terms
    /// - Parameter space: the descendant whose size we want
    /// - Returns: size of `space` scaled to me
    func ensize(_ space: UCSpace) -> UCSize {
        // As far as any UCSpace knows, its own radius is always 1.0. For ensizing,
        // your radius is only ever applied by your parent
        if space === self { return UCSize.unit }

        var sz = space.radius
        var sp = space

        while let parent = sp.parent {
            sz *= parent.radius
            sp = parent
        }

        return UCSize(radius: sz)
    }
}

extension UCSpace {
    func addChild(_ space: UCSpace) {
        precondition(space.parent == nil, "Can't add this child; it already has a parent")
        space.parent = self
        children.append(space)
    }

    @discardableResult
    func removeChild(_ space: UCSpace) -> UCSpace? {
        guard let ix = children.firstIndex(where: { $0 === space }) else { return nil }
        let child = children.remove(at: ix)
        child.parent = nil
        return child
    }

    func removeFromParent() {
        parent?.removeChild(self)
    }
}

extension UCSpace: CustomDebugStringConvertible {
    var debugDescription: String {
        "UCSpace("
        + "name: \(name), "
        + "radius: \(zeroish(radius)), "
        + "rotation: \(zeroish(rotation))), "
        + "position \(position), "
        + "anchor \(anchorPoint)"
    }
}

extension UCSpace: Hashable {
    static func == (_ lhs: UCSpace, _ rhs: UCSpace) -> Bool { lhs === rhs }

    func hash(into hasher: inout Hasher) {
        hasher.combine(radius)
        hasher.combine(rotation)
    }
}

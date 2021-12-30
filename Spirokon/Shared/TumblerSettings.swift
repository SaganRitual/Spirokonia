// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation

protocol HasTumblerSettings: AnyObject {
    var colorSpeed: Double { get set }
    var drawDots: Bool { get set }
    var pen: Double { get set }
    var radius: Double { get set }
    var rollMode: AppState.RollMode { get set }
    var showRing: Bool { get set }
    var trailDecay: Double { get set }
}

extension HasTumblerSettings {
    func copy(from appState: AppState) {
        self.colorSpeed = appState.colorSpeed
        self.drawDots = appState.drawDots
        self.pen = appState.pen
        self.radius = appState.radius
        self.rollMode = appState.innerRingRollMode
        self.showRing = appState.innerRingShow
        self.trailDecay = appState.trailDecay
    }

    func copy(to appState: AppState) {
        appState.colorSpeed = self.colorSpeed
        appState.drawDots = self.drawDots
        appState.pen = self.pen
        appState.radius = self.radius
        appState.innerRingRollMode = self.rollMode
        appState.innerRingShow = self.showRing
        appState.trailDecay = self.trailDecay
    }
}

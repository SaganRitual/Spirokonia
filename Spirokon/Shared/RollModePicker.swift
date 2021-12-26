// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct RollModePicker: View {
    let ring: AppState.Ring
    @Binding var rollMode: AppState.RollMode

    func getRollModes() -> [AppState.RollMode] {
        if case AppState.Ring.outerRing = ring { return [.fullStop, .normal] }
        else                                   { return [.fullStop, .compensate, .normal] }
    }

    func makePickerSegment(for mode: AppState.RollMode) -> some View {
        let image: Image

        switch mode {
        case .fullStop:   image = Image(systemName: "xmark.circle.fill")
        case .compensate: image = Image(systemName: "gobackward")
        case .normal:     image = Image(systemName: "play.circle.fill")

        case .doesNotRoll:
            fatalError("Shouldn't be in here for a non-roller (a pen)")
        }

        return image.tag(mode)
    }

    func makeRollModePicker() -> some View {
        let rollModes = getRollModes()

        return Picker("", selection: $rollMode) {
            ForEach(rollModes.indices) { makePickerSegment(for: rollModes[$0]) }
        }
        .pickerStyle(.segmented)
    }

    var body: some View {
        makeRollModePicker()
    }
}

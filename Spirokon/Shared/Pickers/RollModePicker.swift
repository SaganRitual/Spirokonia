// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct RollModePicker: View {
    let forMainRing: Bool
    @Binding var rollMode: AppDefinitions.RollMode

    func getRollModes() -> [AppDefinitions.RollMode] {
        if forMainRing { return [.sticky, .normal] }
        else           { return [.sticky, .compensate, .normal] }
    }

    func makePickerSegment(for mode: AppDefinitions.RollMode) -> some View {
        let image: Image

        switch mode {
        case .sticky:     image = Image(systemName: "xmark.circle.fill")
        case .compensate: image = Image(systemName: "gobackward")
        case .normal:     image = Image(systemName: "play.circle.fill")

        case .doesNotRoll:
            fatalError("Shouldn't be in here for a non-roller (a pen)")
        }

        return image.tag(mode)
    }

    func makeRollModePicker() -> some View {
        let rollModes = getRollModes()

        return Picker("Roll", selection: $rollMode) {
            ForEach(rollModes.indices) { makePickerSegment(for: rollModes[$0]) }
        }
        .pickerStyle(.segmented)
    }

    var body: some View {
        makeRollModePicker()
    }
}

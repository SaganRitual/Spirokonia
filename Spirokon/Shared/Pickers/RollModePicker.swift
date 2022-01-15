// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct RollModePicker: View {
    let forMainRing: Bool
    @Binding var rollMode: AppDefinitions.RollMode

    func getRollModes() -> [AppDefinitions.RollMode] {
        if forMainRing { return [.fullStop, .cycloid] }
        else           { return [.sticky, .compensate, .cycloid, .flattened] }
    }

    func makePickerSegment(for mode: AppDefinitions.RollMode) -> some View {
        let image: Image

        switch mode {
        case .compensate: image = Image(systemName: "gobackward")
        case .cycloid:    image = Image(systemName: "play.circle")

        case .flattened: image = forMainRing ?
            Image(systemName: "play.circle") : Image(systemName: "goforward.plus")

        case .fullStop:   fallthrough
        case .sticky:     image = Image(systemName: "xmark.circle.fill")

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

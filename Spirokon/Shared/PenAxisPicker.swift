// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct PenAxisPicker: View {
    @Binding var penAxis: Int

    func makePickerSegment(for mode: AppDefinitions.RollMode) -> some View {
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

    var body: some View {
        return Picker("Roll", selection: $penAxis) {
            ForEach(1..<5) {
                Image(systemName: "0\($0).circle").tag($0 - 1)
            }
        }
        .pickerStyle(.segmented)
    }
}

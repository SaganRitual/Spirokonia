// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct TumblerSettingSlider: View {
    @Binding var stepKey: Int
    @Binding var value: Double

    @State private var showingStepPicker = false
    @State private var stepSize: Double?

    let iconName: String
    let label: String
    let range: ClosedRange<Double>
    let stepSizeOverride: Double?

    init(
        value: Binding<Double>, iconName: String, label: String,
        range: ClosedRange<Double>, stepKey: Binding<Int>
    ) {
        self._value = value
        self._stepKey = stepKey
        self.iconName = iconName
        self.label = label
        self.range = range
        self.stepSizeOverride = nil
    }

    init(
        value: Binding<Double>, iconName: String, label: String,
        range: ClosedRange<Double>, stepSizeOverride: Double
    ) {
        self._value = value
        self._stepKey = Binding(get: { 0 }, set: { _ in })
        self.iconName = iconName
        self.label = label
        self.range = range
        self.stepSizeOverride = stepSizeOverride
    }

    func setStepSize() {
        if let s = SliderStepPicker.steps.getStepFactor(prime: stepKey) {
            let fullSize = range.upperBound - range.lowerBound
            self.stepSize = fullSize * s
        } else {
            self.stepSize = nil
        }
    }

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.headline)
                .onTapGesture {
                    // The override allows us to prevent the slider step size being changed
                    if stepSizeOverride == nil { showingStepPicker.toggle() }
                }

            ZStack {
                if showingStepPicker {
                    SliderStepPicker(step: $stepKey)
                        .onDisappear(perform: setStepSize)
                } else {
                    HStack {
                        if let stepSizeOverride = stepSizeOverride {
                            Text(String(format: "% 7.0f", value))
                            Slider(value: $value, in: range, step: stepSizeOverride, label: {})
                        } else if let stepSize = stepSize {
                            Text(String(format: "% 7.3f", value))
                            Slider(value: $value, in: range, step: stepSize, label: {})
                        } else {
                            Text(String(format: "% 7.3f", value))
                            Slider(value: $value, in: range, label: {})
                        }
                    }
                    .onAppear(perform: setStepSize)
                }
            }
        }
        .font(.body.monospaced())
    }
}

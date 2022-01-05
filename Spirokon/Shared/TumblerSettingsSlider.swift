// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct TumblerSettingSlider: View {
    @Binding var value: Double
    @State private var showingStepPicker = false
    @State var step = 0
    @State private var stepSize: Double?

    let iconName: String
    let label: String
    let range: ClosedRange<Double>
    let showTextLabel: Bool

    init(
        value: Binding<Double>, iconName: String, label: String, range: ClosedRange<Double>,
        showTextLabel: Bool
    ) {
        self._value = value
        self.iconName = iconName
        self.label = label
        self.range = range
        self.showTextLabel = showTextLabel
    }

    init(
        value: Binding<Double>, iconName: String, label: String, range: ClosedRange<Double>,
        showTextLabel: Bool, step: Double? = nil
    ) {
        self._value = value
        self.iconName = iconName
        self.label = label
        self.range = range
        self.showTextLabel = showTextLabel
        self.stepSize = step
    }

    var body: some View {
        HStack {
            if showTextLabel {
                HStack {
                    Text(label)
                }
                .frame(width: 150)
            } else {
                Image(systemName: iconName)
                    .font(.headline)
                    .frame(width: 35)
                    .onTapGesture { showingStepPicker.toggle() }
            }

            Spacer()

            ZStack {
                if showingStepPicker {
                    SliderStepPicker(step: $step)
                        .onDisappear {
                            if let s = SliderStepPicker.steps.getStepFactor(prime: step) {
                                let fullSize = range.upperBound - range.lowerBound
                                self.stepSize = fullSize * s
                            } else {
                                self.stepSize = nil
                            }
                        }
                } else {
                    HStack {
                        Text(String(format: "% 5.03f", value))

                        if let stepSize = stepSize {
                            Slider(value: $value, in: range, step: stepSize, label: {})
                        } else {
                            Slider(value: $value, in: range, label: {})
                        }
                    }
                }
            }
        }
        .font(.body.monospaced())
    }
}

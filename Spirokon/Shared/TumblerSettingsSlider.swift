// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct TumblerSettingSlider: View {
    @Binding var value: Double

    let iconName: String
    let label: String
    let range: ClosedRange<Double>
    let showTextLabel: Bool
    let stepSize: Double?

    struct Steps {
        let stepsKeys = [0, 2, 3, 5]
        let stepsValues: [Double?] = [nil, 16.0, 12.0, 20.0]

        func getStepFactor(prime: Int) -> Double? {
            if let s = stepsValues[stepsKeys.firstIndex(of: prime)!] {
                return 1.0 / s
            } else {
                return nil
            }
        }
    }

    static let steps = Steps()

    init(
        value: Binding<Double>, iconName: String, label: String, range: ClosedRange<Double>,
        showTextLabel: Bool, stepFactor: Int
    ) {
        self._value = value
        self.iconName = iconName
        self.label = label
        self.range = range
        self.showTextLabel = showTextLabel

        if let s = Self.steps.getStepFactor(prime: stepFactor) {
            let fullSize = range.upperBound - range.lowerBound
            self.stepSize = fullSize * s
        } else {
            self.stepSize = nil
        }
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
                    Spacer()
                    Text("\(value.as3())")
                }
                .frame(width: 150)
            } else {
                Image(systemName: iconName).font(.largeTitle)
                    .frame(width: 50)
                Spacer()
                Text("\(value.as3())")
            }

            if let stepSize = stepSize {
                Slider(value: $value, in: range, step: stepSize, label: {})
            } else {
                Slider(value: $value, in: range, label: {})
            }
        }.font(.body.monospaced())
    }
}

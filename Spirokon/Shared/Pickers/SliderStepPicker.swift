// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct SliderStepPicker: View {
    struct Steps {
        let stepsKeys: [Int] = [0, 2, 3, 5, 4, 6, 10]
        let stepsValues: [Double?] = [nil, 16.0, 12.0, 20.0, 32.0, 24.0, 40.0]

        func getStepFactor(prime: Int) -> Double? {
            if let s = stepsValues[stepsKeys.firstIndex(of: prime)!] {
                return 1.0 / s
            } else {
                return nil
            }
        }
    }

    static let steps = Steps()

    @Binding var step: Int

    var body: some View {
        Picker("Step", selection: $step) {
            ForEach(SliderStepPicker.steps.stepsKeys, id: \.self) {
                if $0 == 0 {
                    Image(systemName: "infinity").tag($0)
                } else {
                    Text("\($0)").tag($0)
                }
            }
        }
        .pickerStyle(.segmented)
    }
}

struct SliderStepPicker_Previews: PreviewProvider {
    @State static private var step = 0
    static var previews: some View {
        SliderStepPicker(step: $step)
    }
}

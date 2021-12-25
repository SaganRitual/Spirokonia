// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct TumblerSettingSlider: View {
    @Binding var value: Double

    let iconName: String
    let label: String
    let range: ClosedRange<Double>
    let showTextLabel: Bool

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
            }

            Slider(
                value: $value,
                in: range,
                label: {}
            )
        }.font(.body.monospaced())
    }
}

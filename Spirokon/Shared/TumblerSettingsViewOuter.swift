// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct TumblerSettingsViewOuter: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack {
            HStack {
                RollModePicker(ring: .outerRing, rollMode: $appState.outerRingRollMode)
                TogglesView(
                    ring: .outerRing, drawDots: Binding(get: { false }, set: { _ in }),
                    showRing: $appState.showRingOuter
                )
            }

            TumblerSettingSlider(
                value: $appState.outerRingRadius, iconName: "circle", label: "Scale",
                range: AppState.unitRange, showTextLabel: AppState.showTextLabels
            )
        }
    }
}

struct TumblerSettingsViewOuter_Previews: PreviewProvider {
    static var previews: some View {
        TumblerSettingsViewOuter()
    }
}

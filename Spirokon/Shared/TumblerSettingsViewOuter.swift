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
                    showRing: $appState.outerRingShow
                )
            }

            TumblerSettingSlider(
                value: $appState.cycleSpeed, iconName: "speedometer", label: "Speed",
                range: AppState.cycleSpeedRange, showTextLabel: AppState.showTextLabels
            )

            TumblerSettingSlider(
                value: $appState.outerRingRadius, iconName: "circle", label: "Scale",
                range: AppState.unitRange, showTextLabel: AppState.showTextLabels
            )

            TumblerSettingSlider(
                value: $appState.density, iconName: "circle.dotted", label: "Density",
                range: AppState.dotDensityRange, showTextLabel: AppState.showTextLabels,
                step: 1.0
            )
        }
    }
}

struct TumblerSettingsViewOuter_Previews: PreviewProvider {
    static var previews: some View {
        TumblerSettingsViewOuter()
    }
}

// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct TumblerSettingsViewOuter: View {
    @EnvironmentObject var appModel: AppModel

    var body: some View {
        VStack {
            HStack {
                RollModePicker(forMainRing: true, rollMode: $appModel.outerRingRollMode)
                TogglesView(
                    forMainRing: true, drawDots: Binding(get: { false }, set: { _ in }),
                    showRing: $appModel.outerRingShow
                )
            }

            TumblerSettingSlider(
                value: $appModel.cycleSpeed, iconName: "speedometer", label: "Speed",
                range: AppDefinitions.cycleSpeedRange, stepKey: $appModel.cycleSpeedStepKey
            )

            TumblerSettingSlider(
                value: $appModel.outerRingRadius, iconName: "circle", label: "Scale",
                range: AppDefinitions.unitRange, stepKey: $appModel.outerRingRadiusStepKey

            )

            TumblerSettingSlider(
                value: $appModel.density, iconName: "circle.dotted", label: "Density",
                range: AppDefinitions.dotDensityRange, stepSizeOverride: 1.0
            )
        }
    }
}

struct TumblerSettingsViewOuter_Previews: PreviewProvider {
    static var previews: some View {
        TumblerSettingsViewOuter()
    }
}

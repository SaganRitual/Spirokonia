// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct TumblerSettingsViewInner3: View {
    @EnvironmentObject var appModel: AppModel
    @EnvironmentObject var tumblerSelectorStateMachine: TumblerSelectorStateMachine

    var body: some View {
        VStack {
            TumblerSettingSlider(
                value: $appModel.masterSettingsModel.colorSpeed,
                iconName: "paintbrush", label: "Color", range: AppDefinitions.colorSpeedRange,
                stepKey: $appModel.masterSettingsModel.colorSpeedStepKey
            )

            TumblerSettingSlider(
                value: $appModel.masterSettingsModel.trailDecay, iconName: "timer", label: "Decay",
                range: AppDefinitions.trailDecayRange,
                stepKey: $appModel.masterSettingsModel.trailDecayStepKey
            )
        }
    }
}

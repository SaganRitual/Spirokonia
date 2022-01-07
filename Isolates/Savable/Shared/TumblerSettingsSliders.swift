// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct TumblerSettingsSliders: View {
    @EnvironmentObject var appModel: AppModel

    var body: some View {
        VStack {
            TumblerSettingSlider(
                value: $appModel.masterSettingsModel.radius, iconName: "circle", label: "Radius",
                range: AppDefinitions.unitRange, stepKey: $appModel.masterSettingsModel.radiusStepKey
            )

            TumblerSettingSlider(
                value: $appModel.masterSettingsModel.pen, iconName: "pencil", label: "Pen",
                range: AppDefinitions.unitRange, stepKey: $appModel.masterSettingsModel.penStepKey
            )

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

struct TumblerSettingsSliders_Previews: PreviewProvider {
    static let appModel = AppModel()

    static var previews: some View {
        TumblerSettingsSliders()
            .environmentObject(appModel)
    }
}

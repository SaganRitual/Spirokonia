// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct TumblerSettingsSliders: View {
    @EnvironmentObject var appState: AppState

    let step: Int

    var body: some View {
        VStack {
            TumblerSettingSlider(
                value: $appState.radius, iconName: "circle", label: "Radius",
                range: AppState.unitRange, showTextLabel: AppState.showTextLabels,
                stepFactor: step
            )

            TumblerSettingSlider(
                value: $appState.pen, iconName: "pencil", label: "Pen",
                range: AppState.unitRange, showTextLabel: AppState.showTextLabels,
                stepFactor: step
            )

            TumblerSettingSlider(
                value: $appState.colorSpeed, iconName: "paintbrush", label: "Color",
                range: AppState.colorSpeedRange, showTextLabel: AppState.showTextLabels
            )

            TumblerSettingSlider(
                value: $appState.trailDecay, iconName: "timer", label: "Decay",
                range: AppState.trailDecayRange, showTextLabel: AppState.showTextLabels
            )
        }
    }
}

struct TumblerSettingsSliders_Previews: PreviewProvider {
    static let appState = AppState()

    static var previews: some View {
        TumblerSettingsSliders(step: 1)
            .environmentObject(appState)
    }
}

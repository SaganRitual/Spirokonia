// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct TumblerSettingsViewMain: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack {
            TumblerSettingSlider(
                value: $appState.cycleSpeed, iconName: "speedometer", label: "Speed",
                range: AppState.cycleSpeedRange, showTextLabel: AppState.showTextLabels
            )

            TumblerSettingSlider(
                value: $appState.density, iconName: "circle.dotted", label: "Density",
                range: AppState.dotDensityRange, showTextLabel: AppState.showTextLabels
            )
        }
    }
}

struct TumblerSettingsViewMain_Previews: PreviewProvider {
    static var previews: some View {
        TumblerSettingsViewMain()
    }
}

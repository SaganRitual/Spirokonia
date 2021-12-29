// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct TumblerSettingsViewInner: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack {
            HStack {
                RollModePicker(ring: .innerRing(1), rollMode: $appState.innerRingRollMode)
                TogglesView(
                    ring: .innerRing(1), drawDots: $appState.drawDotsInner,
                    showRing: $appState.showRingInner
                )
            }

            TumblerSettingSlider(
                value: $appState.radius, iconName: "circle", label: "Radius",
                range: AppState.unitRange, showTextLabel: AppState.showTextLabels
            )

            TumblerSettingSlider(
                value: $appState.pen, iconName: "pencil", label: "Pen",
                range: AppState.unitRange, showTextLabel: AppState.showTextLabels
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

struct TumblerSettingsViewInner_Previews: PreviewProvider {
    static var previews: some View {
        TumblerSettingsViewInner().environmentObject(AppState())
    }
}

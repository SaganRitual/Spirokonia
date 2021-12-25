// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct ContentView: View {
    @ObservedObject var appState = AppState()

    var body: some View {
        VStack {
            TumblerSettingSlider(
                value: $appState.cycleSpeed, iconName: "speedometer", label: "Speed",
                range: AppState.cycleSpeedRange, showTextLabel: AppState.showTextLabels
            )

            TumblerSettingSlider(
                value: $appState.outerRingRadius, iconName: "circle", label: "Scale",
                range: AppState.unitRange, showTextLabel: AppState.showTextLabels
            )

            TumblerSettingSlider(
                value: $appState.radius, iconName: "circle", label: "Radius",
                range: AppState.unitRange, showTextLabel: AppState.showTextLabels
            )

            TumblerSettingSlider(
                value: $appState.pen, iconName: "pencil", label: "Pen",
                range: AppState.unitRange, showTextLabel: AppState.showTextLabels
            )

            TumblerSettingSlider(
                value: $appState.density, iconName: "circle.dotted", label: "Density",
                range: AppState.dotDensityRange, showTextLabel: AppState.showTextLabels
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

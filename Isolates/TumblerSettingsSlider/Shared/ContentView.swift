// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct ContentView: View {
    @ObservedObject var appModel = AppModel()

    var body: some View {
        VStack {
            TumblerSettingSlider(
                value: $appModel.cycleSpeed, iconName: "speedometer", label: "Speed",
                range: AppModel.cycleSpeedRange, showTextLabel: AppModel.showTextLabels
            )

            TumblerSettingSlider(
                value: $appModel.outerRingRadius, iconName: "circle", label: "Scale",
                range: AppModel.unitRange, showTextLabel: AppModel.showTextLabels
            )

            TumblerSettingSlider(
                value: $appModel.radius, iconName: "circle", label: "Radius",
                range: AppModel.unitRange, showTextLabel: AppModel.showTextLabels
            )

            TumblerSettingSlider(
                value: $appModel.pen, iconName: "pencil", label: "Pen",
                range: AppModel.unitRange, showTextLabel: AppModel.showTextLabels
            )

            TumblerSettingSlider(
                value: $appModel.density, iconName: "circle.dotted", label: "Density",
                range: AppModel.dotDensityRange, showTextLabel: AppModel.showTextLabels
            )

            TumblerSettingSlider(
                value: $appModel.colorSpeed, iconName: "paintbrush", label: "Color",
                range: AppModel.colorSpeedRange, showTextLabel: AppModel.showTextLabels
            )

            TumblerSettingSlider(
                value: $appModel.trailDecay, iconName: "timer", label: "Decay",
                range: AppModel.trailDecayRange, showTextLabel: AppModel.showTextLabels
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

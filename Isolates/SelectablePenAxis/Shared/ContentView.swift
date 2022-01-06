// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var pixoniaScene: PixoniaScene

    var body: some View {
        VStack {
            Group {
                TumblerSettingSlider(
                    value: $appState.texture1Radius, iconName: "circle", label: "Texture Radius",
                    range: 0...2.0, showTextLabel: false
                )

                TumblerSettingSlider(
                    value: $appState.texture1PositionR, iconName: "r.circle", label: "PositionR",
                    range: -2.0...2.0, showTextLabel: false
                )

                TumblerSettingSlider(
                    value: $appState.texture1Rotation, iconName: "arrow.clockwise.circle", label: "Rotation",
                    range: (-2.0 * .tau)...(2.0 * .tau), showTextLabel: false
                )
            }.padding(.bottom)

            Group {
                TumblerSettingSlider(
                    value: $appState.texture2Radius, iconName: "circle", label: "Texture Radius",
                    range: 0...2.0, showTextLabel: false
                )

                TumblerSettingSlider(
                    value: $appState.texture2PositionR, iconName: "r.circle", label: "PositionR",
                    range: -2.0...2.0, showTextLabel: false
                )

                TumblerSettingSlider(
                    value: $appState.texture2Rotation, iconName: "arrow.clockwise.circle", label: "Rotation",
                    range: (-2.0 * .tau)...(2.0 * .tau), showTextLabel: false
                )
            }.padding(.bottom)

            Group {
                TumblerSettingSlider(
                    value: $appState.texture3Radius, iconName: "circle", label: "Texture Radius",
                    range: 0...2.0, showTextLabel: false
                )

                TumblerSettingSlider(
                    value: $appState.texture3PositionR, iconName: "r.circle", label: "PositionR",
                    range: -2.0...2.0, showTextLabel: false
                )

                TumblerSettingSlider(
                    value: $appState.texture3Rotation, iconName: "arrow.clockwise.circle", label: "Rotation",
                    range: (-2.0 * .tau)...(2.0 * .tau), showTextLabel: false
                )
            }.padding(.bottom)

            Group {
                TumblerSettingSlider(
                    value: $appState.texture4Radius, iconName: "circle", label: "Texture Radius",
                    range: 0...2.0, showTextLabel: false
                )

                TumblerSettingSlider(
                    value: $appState.texture4PositionR, iconName: "r.circle", label: "PositionR",
                    range: -2.0...2.0, showTextLabel: false
                )

                TumblerSettingSlider(
                    value: $appState.texture4Rotation, iconName: "arrow.clockwise.circle", label: "Rotation",
                    range: (-2.0 * .tau)...(2.0 * .tau), showTextLabel: false
                )
            }.padding(.bottom)

            TumblerSettingSlider(
                value: $appState.nibPositionR, iconName: "pencil", label: "Pen",
                range: -1.0...1.0, showTextLabel: false
            )

            PixoniaView(scene: pixoniaScene)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

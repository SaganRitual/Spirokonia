// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appModel: AppModel
    @EnvironmentObject var pixoniaScene: PixoniaScene

    var body: some View {
        VStack {
            Group {
                TumblerSettingSlider(
                    value: $appModel.texture1Radius, iconName: "circle", label: "Texture Radius",
                    range: 0...2.0, showTextLabel: false
                )

                TumblerSettingSlider(
                    value: $appModel.texture1PositionR, iconName: "r.circle", label: "PositionR",
                    range: -2.0...2.0, showTextLabel: false
                )

                TumblerSettingSlider(
                    value: $appModel.texture1Rotation, iconName: "arrow.clockwise.circle", label: "Rotation",
                    range: (-2.0 * .tau)...(2.0 * .tau), showTextLabel: false
                )
            }.padding(.bottom)

            Group {
                TumblerSettingSlider(
                    value: $appModel.texture2Radius, iconName: "circle", label: "Texture Radius",
                    range: 0...2.0, showTextLabel: false
                )

                TumblerSettingSlider(
                    value: $appModel.texture2PositionR, iconName: "r.circle", label: "PositionR",
                    range: -2.0...2.0, showTextLabel: false
                )

                TumblerSettingSlider(
                    value: $appModel.texture2Rotation, iconName: "arrow.clockwise.circle", label: "Rotation",
                    range: (-2.0 * .tau)...(2.0 * .tau), showTextLabel: false
                )
            }.padding(.bottom)

            Group {
                TumblerSettingSlider(
                    value: $appModel.texture3Radius, iconName: "circle", label: "Texture Radius",
                    range: 0...2.0, showTextLabel: false
                )

                TumblerSettingSlider(
                    value: $appModel.texture3PositionR, iconName: "r.circle", label: "PositionR",
                    range: -2.0...2.0, showTextLabel: false
                )

                TumblerSettingSlider(
                    value: $appModel.texture3Rotation, iconName: "arrow.clockwise.circle", label: "Rotation",
                    range: (-2.0 * .tau)...(2.0 * .tau), showTextLabel: false
                )
            }.padding(.bottom)

            Group {
                TumblerSettingSlider(
                    value: $appModel.texture4Radius, iconName: "circle", label: "Texture Radius",
                    range: 0...2.0, showTextLabel: false
                )

                TumblerSettingSlider(
                    value: $appModel.texture4PositionR, iconName: "r.circle", label: "PositionR",
                    range: -2.0...2.0, showTextLabel: false
                )

                TumblerSettingSlider(
                    value: $appModel.texture4Rotation, iconName: "arrow.clockwise.circle", label: "Rotation",
                    range: (-2.0 * .tau)...(2.0 * .tau), showTextLabel: false
                )
            }.padding(.bottom)

            TumblerSettingSlider(
                value: $appModel.nibPositionR, iconName: "pencil", label: "Pen",
                range: -1.0...1.0, showTextLabel: false
            )

            Picker("Pen Axis", selection: $appModel.penAxis) {
                ForEach(0..<4) {
                    Image(systemName: "\($0).circle").tag($0)
                }
            }
            .pickerStyle(.segmented)


            PixoniaView(scene: pixoniaScene)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

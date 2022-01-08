// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appModel: AppModel
    @EnvironmentObject var pixoniaScene: PixoniaScene

    var body: some View {
        HStack {
            TumblerSettingSlider(
                value: $appModel.radius, iconName: "circle", label: "Radius",
                range: 0.0...1.0, showTextLabel: false
            )

            PixoniaView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

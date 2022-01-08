// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct PixoniaAppView: View {
    @ObservedObject var appModel: AppModel
    @ObservedObject var pixoniaScene: PixoniaScene

    var body: some View {
        PixoniaView(appModel: appModel, scene: pixoniaScene)
    }
}

struct PixoniaAppView_Previews: PreviewProvider {
    static var appModel = AppModel()
    static var pixoniaScene = PixoniaScene(appModel: ObservedObject(initialValue: appModel))

    static var previews: some View {
        PixoniaAppView(appModel: appModel, pixoniaScene: pixoniaScene)
    }
}

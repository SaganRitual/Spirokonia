// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct TumblerSettingsViewInner1: View {
    @EnvironmentObject var appModel: AppModel
    @EnvironmentObject var tumblerSelectorStateMachine: TumblerSelectorStateMachine

    var body: some View {
        HStack {
            RollModePicker(forMainRing: false, rollMode: $appModel.masterSettingsModel.rollMode)
            TogglesView(
                forMainRing: false, drawDots: $appModel.masterSettingsModel.drawDots,
                showRing: $appModel.masterSettingsModel.showRing
            )
        }
    }
}

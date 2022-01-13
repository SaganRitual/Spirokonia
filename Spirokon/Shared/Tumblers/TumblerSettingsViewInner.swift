// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct TumblerSettingsViewInner: View {
    @EnvironmentObject var appModel: AppModel
    @EnvironmentObject var tumblerSelectorStateMachine: TumblerSelectorStateMachine

    var body: some View {
        VStack {
            HStack {
                RollModePicker(forMainRing: false, rollMode: $appModel.masterSettingsModel.rollMode)
                TogglesView(
                    forMainRing: false, drawDots: $appModel.masterSettingsModel.drawDots,
                    showRing: $appModel.masterSettingsModel.showRing
                )
            }

            HStack {
                PenAxisPicker(penAxis: $appModel.masterSettingsModel.penAxis)
                RollRelationshipPicker(rollRelationship: $appModel.masterSettingsModel.rollRelationship)
            }

            TumblerSettingsSliders()
        }
    }
}

struct TumblerSettingsViewInner_Previews: PreviewProvider {
    static var previews: some View {
        TumblerSettingsViewInner().environmentObject(AppModel())
    }
}

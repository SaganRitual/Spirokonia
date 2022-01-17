// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct TumblerSettingsViewInner2: View {
    @EnvironmentObject var appModel: AppModel
    @EnvironmentObject var tumblerSelectorStateMachine: TumblerSelectorStateMachine

    var body: some View {
        VStack {
            TumblerSettingSlider(
                value: $appModel.masterSettingsModel.radius, iconName: "circle", label: "Radius",
                range: AppDefinitions.unitRange, stepKey: $appModel.masterSettingsModel.radiusStepKey
            )

            TumblerSettingSlider(
                value: $appModel.masterSettingsModel.pen, iconName: "pencil", label: "Pen",
                range: AppDefinitions.unitRange, stepKey: $appModel.masterSettingsModel.penStepKey
            )
        }
    }
}

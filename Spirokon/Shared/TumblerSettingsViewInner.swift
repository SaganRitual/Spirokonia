// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct TumblerSettingsViewInner: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var tumblerSelectorStateMachine: TumblerSelectorStateMachine

    @State private var step: Int = 0

    var body: some View {
        VStack {
            HStack {
                RollModePicker(ring: .innerRing(1), rollMode: $appState.innerRingRollMode)
                TogglesView(
                    ring: .innerRing(1), drawDots: $appState.drawDots,
                    showRing: $appState.innerRingShow
                )
            }

            Picker("Step", selection: $step) {
                ForEach(TumblerSettingSlider.steps.stepsKeys, id: \.self) {
                    if $0 == 0 {
                        Image(systemName: "infinity").tag($0)
                    } else {
                        Text("\($0)").tag($0)
                    }
                }
            }
            .pickerStyle(.segmented)

            TumblerSettingsSliders(step: step)
        }
    }
}

struct TumblerSettingsViewInner_Previews: PreviewProvider {
    static var previews: some View {
        TumblerSettingsViewInner().environmentObject(AppState())
    }
}

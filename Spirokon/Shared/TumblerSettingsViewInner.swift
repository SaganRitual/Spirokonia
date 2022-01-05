// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct TumblerSettingsViewInner: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var tumblerSelectorStateMachine: TumblerSelectorStateMachine

    var body: some View {
        VStack {
            HStack {
                RollModePicker(ring: .innerRing(1), rollMode: $appState.innerRingRollMode)
                TogglesView(
                    ring: .innerRing(1), drawDots: $appState.drawDots,
                    showRing: $appState.innerRingShow
                )
            }

            TumblerSettingsSliders()
        }
    }
}

struct TumblerSettingsViewInner_Previews: PreviewProvider {
    static var previews: some View {
        TumblerSettingsViewInner().environmentObject(AppState())
    }
}

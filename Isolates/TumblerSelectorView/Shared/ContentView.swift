// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct ContentView: View {
    @ObservedObject var appState = AppState()
    @ObservedObject var tumblerSelectorStateMachine: TumblerSelectorStateMachine

    init() {
        _tumblerSelectorStateMachine = ObservedObject(
            initialValue: TumblerSelectorStateMachine(appState: _appState)
        )
    }


    var body: some View {
        TumblerSelectorView(appState: appState, tumblerSelectorStateMachine: tumblerSelectorStateMachine)
            .padding(.top)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

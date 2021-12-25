// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct TumblerSelectorView: View {
    let fonts: [SwiftUI.Font] = [.largeTitle, .title, .body, .caption]

    @ObservedObject var appState: AppState

    var body: some View {
        HStack(alignment: .bottom) {
            ForEach(appState.tumblerSelectorSwitches.indices) { ix in
                Spacer()
                Toggle(
                    isOn: $appState.tumblerSelectorSwitches[ix],
                    label: {
                        if ix == 0 {
                            Image(systemName: "circle").font(.largeTitle)
                        } else if ix == 1 {
                            ZStack {
                                Image(systemName: "circle").font(.largeTitle)
                                Image(systemName: "circle").font(.title2)
                            }
                        } else if ix == 2 {
                            ZStack {
                                Image(systemName: "circle").font(.largeTitle)
                                Image(systemName: "circle").font(.title2)
                                Image(systemName: "circle").font(.caption)
                            }
                        } else {
                            ZStack {
                                Image(systemName: "circle").font(.largeTitle)
                                Image(systemName: "circle").font(.title2)
                                Image(systemName: "smallcircle.filled.circle").font(.caption)
                            }
                        }
                    }
                )
                .toggleStyle(.button)
                .controlSize(.regular)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                Spacer()
            }
        }
    }
}

struct Previews_TumblerSelector_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}

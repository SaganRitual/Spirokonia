// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct TogglesView: View {
    let ring: AppState.Ring

    @Binding var drawDots: Bool
    @Binding var showRing: Bool

    func getToggles() -> [AppState.ToggleType] {
        if case AppState.Ring.outerRing = ring { return [.showRing] }
        else                                   { return [.showRing, .drawDots] }
    }

    func makeToggle(_ toggleType: AppState.ToggleType) -> some View {
        switch (ring, toggleType) {
        case (.innerRing, .drawDots):
            return Toggle(isOn: $drawDots, label: { Image(systemName: "rectangle.and.pencil.and.ellipsis") })
                .toggleStyle(.button)
                .controlSize(SwiftUI.ControlSize.small)

        case (_, .showRing):
            return Toggle(isOn: $showRing, label: { Image(systemName: "eye.circle.fill") })
                .toggleStyle(.button)
                .controlSize(SwiftUI.ControlSize.small)

        default: fatalError()
        }
    }

    func makeToggles() -> some View {
        let toggles = getToggles()

        return HStack { ForEach(toggles, id: \.self) { makeToggle($0) } }
    }

    var body: some View {
        makeToggles()
    }
}

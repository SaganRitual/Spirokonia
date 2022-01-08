// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct TogglesView: View {
    let forMainRing: Bool

    @Binding var drawDots: Bool
    @Binding var showRing: Bool

    func getToggles() -> [AppDefinitions.ToggleType] {
        if forMainRing { return [.showRing] }
        else           { return [.showRing, .drawDots] }
    }

    func makeToggle(_ toggleType: AppDefinitions.ToggleType) -> some View {
        switch (forMainRing, toggleType) {
        case (false, .drawDots):
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

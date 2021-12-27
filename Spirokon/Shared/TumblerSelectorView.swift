// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct TumblerSelectorView: View {
    let fonts: [SwiftUI.Font] = [.largeTitle, .title, .body, .caption]

    @ObservedObject var appState: AppState
    @ObservedObject var tumblerSelectorStateMachine: TumblerSelectorStateMachine

    struct ButtonDescriptor {
        let zStack: Bool
        let nameFont: [(String, Font)]
    }

    func makeButton(_ ring: AppState.Ring) -> some View {
        let bd: ButtonDescriptor
        switch ring {
        case .innerRing(1):
            bd = ButtonDescriptor(
                zStack: false,
                nameFont: [("circle", .largeTitle)]
            )
        case .innerRing(2):
            bd = ButtonDescriptor(
                zStack: true,
                nameFont: [("circle", .largeTitle), ("circle", .title2)]
            )
        case .innerRing(3):
            bd = ButtonDescriptor(
                zStack: true,
                nameFont: [("circle", .largeTitle), ("circle", .title2), ("circle", .caption)]
            )
        case .innerRing(4):
            bd = ButtonDescriptor(
                zStack: true,
                nameFont: [
                    ("circle", .largeTitle),
                    ("circle", .title2),
                    ("smallcircle.filled.circle", .caption)
                ]
            )

        default: fatalError()
        }

        return ZStack {
            ForEach(bd.nameFont.indices) { index in
                Image(systemName: bd.nameFont[index].0)
                    .font(bd.nameFont[index].1)
            }
        }
    }

    struct TumblerSelectorButton: ButtonStyle {
        @ObservedObject var appState: AppState
        let ix: Int

        func getBackgroundColor() -> Color {
            switch appState.tumblerSelectorSwitches[ix] {
            case .trueDefinite:  return Color.accentColor
            case .falseDefinite: return Color.gray

            case .trueIndefinite:  fallthrough
            case .falseIndefinite: return Color.indefiniteButtonPress
            }
        }

        func makeBody(configuration: Configuration) -> some View {
            configuration
                .label
                .padding()
                .background(getBackgroundColor())
                .foregroundColor(.white)
                .controlSize(.regular)
                .clipShape(RoundedRectangle(cornerRadius: 15))
        }
    }

    var body: some View {
        HStack(alignment: .bottom) {
            ForEach(appState.tumblerSelectorSwitches.indices) { ix in
                Spacer()
                Button(
                    action: { tumblerSelectorStateMachine.onTap() },
                    label: { makeButton(.innerRing(ix + 1)) }
                )
                .simultaneousGesture(
                    LongPressGesture()
                        .onEnded   { _ in tumblerSelectorStateMachine.endLongPress() }
                        .onChanged { _ in tumblerSelectorStateMachine.changeLongPress(ix) }
                )
                .buttonStyle(TumblerSelectorButton(appState: appState, ix: ix))
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

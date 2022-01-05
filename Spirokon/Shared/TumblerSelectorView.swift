// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct TumblerSelectorView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var tumblerSelectorStateMachine: TumblerSelectorStateMachine

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
                nameFont: [("circle", .title)]
            )
        case .innerRing(2):
            bd = ButtonDescriptor(
                zStack: true,
                nameFont: [("circle", .title)]
            )
        case .innerRing(3):
            bd = ButtonDescriptor(
                zStack: true,
                nameFont: [("circle", .title)]
            )
        case .innerRing(4):
            bd = ButtonDescriptor(
                zStack: true,
                nameFont: [
                    ("circle", .title)
                ]
            )

        default: fatalError()
        }

        return ZStack {
            Image(systemName: bd.nameFont[0].0)
                .font(bd.nameFont[0].1)
                .foregroundColor(AppState.ringColors[ring.ix])
                .scaleEffect(1.75)
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
            case .falseIndefinite: return Color.secondary
            }
        }

        func makeBody(configuration: Configuration) -> some View {
            configuration
                .label
                .padding()
                .background(getBackgroundColor())
                .foregroundColor(.white)
                .controlSize(.mini)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .scaleEffect(0.75)
        }
    }

    var body: some View {
        HStack(alignment: .bottom) {
            Spacer()
            ForEach(appState.tumblerSelectorSwitches.indices) { ix in
                Button(
                    action: { tumblerSelectorStateMachine.endPress() },
                    label: { makeButton(.innerRing(ix + 1)) }
                )
                .simultaneousGesture(
                    LongPressGesture()
                        .onEnded   { _ in tumblerSelectorStateMachine.longPressDetected() }
                        .onChanged { _ in tumblerSelectorStateMachine.beginPress(ix) }
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

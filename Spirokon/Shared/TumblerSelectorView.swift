// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct TumblerSelectorView: View {
    @EnvironmentObject var appModel: AppModel
    @EnvironmentObject var tumblerSelectorStateMachine: TumblerSelectorStateMachine

    struct TumblerSelectorButton: ButtonStyle {
        @ObservedObject var appModel: AppModel
        let ix: Int

        func getBackgroundColor() -> Color {
            switch appModel.tumblerSelectorSwitches[ix] {
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
            ForEach(appModel.tumblerSelectorSwitches.indices) { ix in
                Button(
                    action: { tumblerSelectorStateMachine.endPress() },
                    label: {
                        Image(systemName: "circle")
                            .font(.title)
                            .foregroundColor(AppDefinitions.drawingPixieColors[ix])
                            .scaleEffect(1.75)
                    }
                )
                .simultaneousGesture(
                    LongPressGesture()
                        .onEnded   { _ in tumblerSelectorStateMachine.longPressDetected() }
                        .onChanged { _ in tumblerSelectorStateMachine.beginPress(ix) }
                )
                .buttonStyle(TumblerSelectorButton(appModel: appModel, ix: ix))

                Spacer()
            }
        }
    }
}

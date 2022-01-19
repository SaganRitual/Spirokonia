// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct ArenaDiagram: View {
    @EnvironmentObject var appModel: AppModel

    let isLive: Bool

    init(isLive: Bool = false) { self.isLive = isLive }

    func colorSelect(_ color: Color, isDrawing: Bool) -> Color {
        isDrawing ? color : .clear
    }

    func colorSelect(_ color: Color, isSelected: AppDefinitions.TumblerSelectorSwitchState) -> Color {
        isSelected == .trueDefinite ? color : .clear
    }

    func armIndicator(_ ix: Int) -> some View {
        return Rectangle()
            .fill(colorSelect(
                AppDefinitions.drawingPixieColors[ix],
                isDrawing: appModel.drawingTumblerSettingsModels.tumblerSettingsModels[ix].drawDots
            ))
            .frame(
                width: 0.5 * 100 * appModel.drawingTumblerSettingsModels.tumblerSettingsModels[ix].pen,
                height: 10, alignment: .leading
            )
    }

    func ringIndicator(_ ix: Int) -> some View {
        Rectangle()
            .fill(colorSelect(
                AppDefinitions.drawingPixieColors[ix],
                isSelected: appModel.tumblerSelectorSwitches[ix]
            ))
            .frame(
                width: 0.5 * 100 * appModel.drawingTumblerSettingsModels.tumblerSettingsModels[ix].radius,
                height: 10, alignment: .leading
            )
    }

    var body: some View {
        Button(
            action: {
                guard isLive else { return }
                print("Button pressed")
            },

            label: {
                VStack(alignment: .leading, spacing: 0) {
                    Rectangle()
                        .fill(AppDefinitions.platterPixieColor)
                        .frame(
                            width: 0.5 * 100 * appModel.outerRingRadius, height: 10,
                            alignment: .leading
                        )

                    ForEach(0..<4) { ix in
                        Group {
                            ringIndicator(ix)
                            armIndicator(ix)
                        }
                        .border(AppDefinitions.drawingPixieColors[ix], width: 1)
                    }
                }
            }
        )
        .frame(width: 100, height: 90, alignment: .leading)
        .border(Color.gray, width: 2)
    }
}

struct Previews_ArenaDiagram_Previews: PreviewProvider {
    static var previews: some View {
        ArenaDiagram()
            .environmentObject(AppModel())
    }
}

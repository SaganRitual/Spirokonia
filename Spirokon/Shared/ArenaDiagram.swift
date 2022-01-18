// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct ArenaDiagram: View {
    @EnvironmentObject var appModel: AppModel

    var body: some View {
        Button(
            action: {
                print("Button pressed")
            },

            label: {
                VStack(alignment: .leading, spacing: 0) {
                    Rectangle()
                        .fill(AppDefinitions.platterPixieColor)
                        .frame(
                            width: 0.25 * 100 * appModel.outerRingRadius, height: 5,
                            alignment: .leading
                        )

                    ForEach(0..<4) { ix in
                        Rectangle()
                            .fill(AppDefinitions.drawingPixieColors[ix])
                            .frame(
                                width: 0.25 * 100 * appModel.drawingTumblerSettingsModels.tumblerSettingsModels[ix].radius,
                                height: 5, alignment: .leading
                            )

                        Rectangle()
                            .fill(AppDefinitions.drawingPixieColors[ix])
                            .frame(
                                width: 0.25 * 100 * appModel.drawingTumblerSettingsModels.tumblerSettingsModels[ix].pen,
                                height: 5, alignment: .leading
                            )
                    }
                    .frame(alignment: .leading)
                }
            }
        )
        .frame(width: 50, height: 45, alignment: .leading)
    }
}

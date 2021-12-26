// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct ContentView: View {
    @ObservedObject var appState: AppState
    @ObservedObject var pixoniaScene: PixoniaScene

    var body: some View {
        HStack {
            NavigationView {
                VStack {
                    Spacer()

                    Section("Speed") {
                        TumblerSettingSlider(
                            value: $appState.cycleSpeed, iconName: "speedometer", label: "Speed",
                            range: AppState.cycleSpeedRange, showTextLabel: AppState.showTextLabels
                        )
                    }

                    Spacer()

                    Section("Main Ring") {
                        HStack {
                            RollModePicker(ring: .outerRing, rollMode: $appState.outerRingRollMode)
                            TogglesView(
                                ring: .outerRing, drawDots: $appState.drawDotsOuter,
                                showRing: $appState.showRingOuter
                            )
                        }

                        TumblerSettingSlider(
                            value: $appState.outerRingRadius, iconName: "circle", label: "Scale",
                            range: AppState.unitRange, showTextLabel: AppState.showTextLabels
                        )
                    }

                    Spacer()

                    Section("Inner Rings") {
                        TumblerSelectorView(appState: appState)
                            .padding(.top)
                    }

                    Spacer()

                    Section {
                        HStack {
                            RollModePicker(ring: .innerRing, rollMode: $appState.innerRingRollMode)
                            TogglesView(
                                ring: .innerRing, drawDots: $appState.drawDotsInner,
                                showRing: $appState.showRingInner
                            )
                        }

                        TumblerSettingSlider(
                            value: $appState.radius, iconName: "circle", label: "Radius",
                            range: AppState.unitRange, showTextLabel: AppState.showTextLabels
                        )

                        TumblerSettingSlider(
                            value: $appState.pen, iconName: "pencil", label: "Pen",
                            range: AppState.unitRange, showTextLabel: AppState.showTextLabels
                        )

                        TumblerSettingSlider(
                            value: $appState.density, iconName: "circle.dotted", label: "Density",
                            range: AppState.dotDensityRange, showTextLabel: AppState.showTextLabels
                        )

                        TumblerSettingSlider(
                            value: $appState.colorSpeed, iconName: "paintbrush", label: "Color",
                            range: AppState.colorSpeedRange, showTextLabel: AppState.showTextLabels
                        )

                        TumblerSettingSlider(
                            value: $appState.trailDecay, iconName: "timer", label: "Decay",
                            range: AppState.trailDecayRange, showTextLabel: AppState.showTextLabels
                        )
                    }

                    Spacer()
                }
                .navigationTitle("Settings")
                .padding([.leading, .trailing])
            }
            #if os(iOS)
            .navigationViewStyle(StackNavigationViewStyle())
            #endif

            PixoniaView(appState: appState, scene: pixoniaScene)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    @ObservedObject static var appState = AppState()
    static var previews: some View {
        ContentView(appState: AppState(), pixoniaScene: PixoniaScene(appState: _appState))
            .previewInterfaceOrientation(.landscapeRight)
    }
}

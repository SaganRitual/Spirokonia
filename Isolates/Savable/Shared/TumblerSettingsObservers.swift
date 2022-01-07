// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import SwiftUI

class TumblerSettingsObservers {
    var colorSpeed: AnyCancellable!
    var drawDots: AnyCancellable!
    var pen: AnyCancellable!
    var penAxis: AnyCancellable!
    var radius: AnyCancellable!
    var rollMode: AnyCancellable!
    var rollRelationship: AnyCancellable!
    var showRing:  AnyCancellable!
    var trailDecay: AnyCancellable!

    var colorSpeedStep: AnyCancellable!
    var penStep: AnyCancellable!
    var radiusStep: AnyCancellable!
    var trailDecayStep: AnyCancellable!

    var selectionObserver: AnyCancellable!

    let appModel: AppModel
    let tumblerSelectorStateMachine: TumblerSelectorStateMachine

    init(_ appModel: AppModel, _ tumblerSelectorStateMachine: TumblerSelectorStateMachine) {
        self.appModel = appModel
        self.tumblerSelectorStateMachine = tumblerSelectorStateMachine
    }

    func createUpdater<T>(_ triplet: DrawingRingDescriptor<T>) {
        self[keyPath: triplet.observerField] =
            appModel.masterSettingsModel[keyPath: triplet.masterSettingsModelField].sink {
                [weak self] in self?.updater($0, in: triplet.tumblerSettingsModelField)
            }
    }

    func postInit() {
        let bools = [
            DrawingRingDescriptor(\.drawDots, \.$drawDots, \.drawDots),
            DrawingRingDescriptor(\.showRing, \.$showRing, \.showRing)
        ]

        let doubles = [
            DrawingRingDescriptor(\.colorSpeed, \.$colorSpeed, \.colorSpeed),
            DrawingRingDescriptor(\.pen, \.$pen, \.pen),
            DrawingRingDescriptor(\.radius, \.$radius, \.radius),
            DrawingRingDescriptor(\.trailDecay, \.$trailDecay, \.trailDecay)
        ]

        let ints = [
            DrawingRingDescriptor(\.penAxis, \.$penAxis, \.penAxis),
            DrawingRingDescriptor(\.colorSpeedStep, \.$colorSpeedStepKey, \.colorSpeedStepKey),
            DrawingRingDescriptor(\.penStep, \.$penStepKey, \.penStepKey),
            DrawingRingDescriptor(\.radiusStep, \.$radiusStepKey, \.radiusStepKey),
            DrawingRingDescriptor(\.trailDecayStep, \.$trailDecayStepKey, \.trailDecayStepKey)
        ]

        bools.forEach { createUpdater($0) }
        doubles.forEach { createUpdater($0) }
        ints.forEach { createUpdater($0) }

        createUpdater(DrawingRingDescriptor(\.rollMode, \.$rollMode, \.rollMode))
        createUpdater(DrawingRingDescriptor(\.rollRelationship, \.$rollRelationship, \.rollRelationship))

        selectionObserver = tumblerSelectorStateMachine.$indexOfDrivingTumbler.sink {
            [weak self] in guard let myself = self, let newDriverIx = $0 else { return }

            // FIXME: We get notifications before our internal init is complete. Probably an
            // FIXME: indication of a design flaw in our internal init.
            if myself.appModel.drawingTumblerSettingsModels.tumblerSettingsModels.isEmpty { return }

            myself.appModel.masterSettingsModel.copy(
                from: myself.appModel.drawingTumblerSettingsModels.tumblerSettingsModels[newDriverIx]
            )
        }
    }

    func updater<T>(
        _ value: T,
        in tumblerSettingsModelField: ReferenceWritableKeyPath<TumblerSettingsModel, T>
    ) {
        // FIXME: We get notifications before our internal init is complete. Probably an indication
        // FIXME: of a design flaw in our internal init.
        if appModel.drawingTumblerSettingsModels.tumblerSettingsModels.isEmpty { return }

        for (ix, `switch`) in appModel.tumblerSelectorSwitches.enumerated() where `switch`.isTracking {
            let m = appModel.drawingTumblerSettingsModels.tumblerSettingsModels[ix]
            m[keyPath: tumblerSettingsModelField] = value
        }
    }
}

extension TumblerSettingsObservers {
    struct DrawingRingDescriptor<T> {
        let observerField: ReferenceWritableKeyPath<TumblerSettingsObservers, AnyCancellable?>
        let masterSettingsModelField: ReferenceWritableKeyPath<TumblerSettingsModel, Published<T>.Publisher>
        let tumblerSettingsModelField: ReferenceWritableKeyPath<TumblerSettingsModel, T>

        init(
            _ observerField: ReferenceWritableKeyPath<TumblerSettingsObservers, AnyCancellable?>,
            _ masterSettingsModelField: ReferenceWritableKeyPath<TumblerSettingsModel, Published<T>.Publisher>,
            _ tumblerSettingsModelField: ReferenceWritableKeyPath<TumblerSettingsModel, T>
        ) {
            self.observerField = observerField
            self.masterSettingsModelField = masterSettingsModelField
            self.tumblerSettingsModelField = tumblerSettingsModelField
        }
    }
}

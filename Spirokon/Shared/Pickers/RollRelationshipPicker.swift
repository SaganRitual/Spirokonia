// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct RollRelationshipPicker: View {
    @Binding var rollRelationship: AppDefinitions.RollRelationship

    var body: some View {
        Picker("Roll Relationship", selection: $rollRelationship) {
            Image(systemName: "circle.circle").tag(AppDefinitions.RollRelationship.innerToInner)
            Image(systemName: "circle.grid.2x1").tag(AppDefinitions.RollRelationship.outerToOuter)
        }
        .pickerStyle(.segmented)
    }
}

struct RollRelationshipPicker_Previews: PreviewProvider {
    static var previews: some View {
        RollRelationshipPicker(rollRelationship: .constant(.innerToInner))
    }
}

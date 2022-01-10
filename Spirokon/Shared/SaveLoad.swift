// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct SaveLoad: View {
    @EnvironmentObject var appModel: AppModel

    var body: some View {
        VStack {
            HStack {
                ForEach(0..<6) { loadSlot in
                    Button(
                        action: {
                            do {
                                let encoder = JSONEncoder()
                                encoder.outputFormatting = .prettyPrinted
                                let json = try encoder.encode(appModel)
//                                print("Encoded:\n", String(data: json, encoding: .utf8)!)
                                UserDefaults.standard.set(json, forKey: "Model\(loadSlot)")
                                UserDefaults.standard.set(json, forKey: "LastSave")
                            } catch {
                                print("Encode failed \(error)")
                            }
                        },
                        label: { Image(systemName: "square.and.arrow.up") }
                    ).padding(loadSlot == 0 ? .horizontal : .trailing)
                }
            }
            .padding(.bottom)

            HStack {
                ForEach(0..<6) { saveSlot in
                    Button(
                        action: {
                            guard let loaded = UserDefaults.standard.data(forKey: "Model\(saveSlot)") else {
                                return
                            }

//                            print("Loaded (\(saveSlot))", String(data: loaded, encoding: .utf8)!)

                            do {
                                let decoded = try JSONDecoder().decode(AppModel.self, from: loaded)

                                self.appModel.copy(from: decoded)
                            } catch {
                                print("Decode failed \(error)")
                            }
                        },
                        label: { Image(systemName: "square.and.arrow.down") }
                    ).padding(saveSlot == 0 ? .horizontal : .trailing)
                }
            }
        }
    }
}

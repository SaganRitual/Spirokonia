// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct SaveLoad: View {
    @EnvironmentObject var appModel: AppModel

    @State private var selectedFolder: Int = 0
    @StateObject private var savedAppModel = AppModel()

    func load(from slot: Int, toArena: Bool) {
        guard let loaded = UserDefaults.standard.data(forKey: "Model\(slot)") else {
//            print("Nothing saved in slot \(slot); create default")

            if toArena {
                appModel.copy(from: AppModel())
            } else {
                savedAppModel.copy(from: AppModel())
            }
            return
        }

//        print("Loaded (\(slot))", String(data: loaded, encoding: .utf8)!)

        do {
            let decoded = try JSONDecoder().decode(AppModel.self, from: loaded)

            if toArena {
                appModel.copy(from: decoded)
            } else {
                savedAppModel.copy(from: decoded)
            }
        } catch {
//            print("Decode failed \(error)")
            if toArena {
                appModel.copy(from: AppModel())
            } else {
                savedAppModel.copy(from: AppModel())
            }
        }
    }

    var body: some View {
        VStack {
            HStack {
                ArenaDiagram(isLive: false)
                    .environmentObject(savedAppModel)

                VStack {
                    Button(
                        action: { load(from: selectedFolder, toArena: true) },
                        label: { Image(systemName: "chevron.right") }
                    )
                    .padding(.bottom)

                    Button(
                        action: {
                            do {
                                let encoder = JSONEncoder()
                                encoder.outputFormatting = .prettyPrinted
                                let json = try encoder.encode(appModel)
//                                print("Encoded:\n", String(data: json, encoding: .utf8)!)
                                UserDefaults.standard.set(json, forKey: "Model\(selectedFolder)")
                                UserDefaults.standard.set(json, forKey: "LastSave")
                                savedAppModel.copy(from: appModel)
                            } catch {
//                                print("Encode failed \(error)")
                                savedAppModel.copy(from: AppModel())
                            }
                        },
                        label: {
                            Image(systemName: "chevron.left")
                        }
                    )
                }

                ArenaDiagram(isLive: true)
            }
            .padding(.bottom)

            Picker("Saved Sessions", selection: $selectedFolder) {
                ForEach(0..<5) {
                    Image(systemName: "folder").tag($0)
                        .controlSize(.mini)
                }
            }
            .pickerStyle(.segmented)
            .onAppear { load(from: selectedFolder, toArena: false) }
            .onChange(of: selectedFolder) { _ in load(from: selectedFolder, toArena: false) }
        }
    }
}

struct SaveLoad_Previews: PreviewProvider {
    static var previews: some View {
        RunView()
            .environmentObject(AppModel())
    }
}

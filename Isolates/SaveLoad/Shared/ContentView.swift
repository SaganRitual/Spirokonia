// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct ContentView: View {
    enum SaveLoadViewMode {
        case normal, folderSelected(Int)
    }

    @State private var mode: SaveLoadViewMode = .normal
    @State private var selectedFolder: Int = 0

    var body: some View {
        VStack {
            HStack {
                ArenaDiagram(isLive: false)

                VStack {
                    Button(
                        action: {
                            print("load")
                        },
                        label: {
                            Image(systemName: "chevron.right")
                        }
                    )
                    .padding(.bottom)
                    
                    Button(
                        action: {
                            print("save")
                        },
                        label: {
                            Image(systemName: "chevron.left")
                        }
                    )
                }

                ArenaDiagram(isLive: true)
            }
            
            Picker("Saved Sessions", selection: $selectedFolder) {
                ForEach(0..<5) {
                    Image(systemName: "folder").tag($0)
                        .controlSize(.mini)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppModel())
    }
}

//
//  GeneralSettingsView.swift
//  Banksia
//
//  Created by Dave Coleman on 16/11/2023.
//

import SwiftUI
import SwiftData
import Swatches

struct GeneralSettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var pref: Preferences
    
    @Environment(BanksiaHandler.self) private var bk
    
    var body: some View {
        
        @Bindable var bk = bk
        
        Form {
            
            LabeledContent {
                Slider(
                    value: $bk.uiDimming,
                    in: 0.01...0.89) { changed in
                        if changed {
                            pref.uiDimming = bk.uiDimming
                        }
                    }
                    .controlSize(.mini)
                    .tint(Swatch.lightGrey.colour)
                    .frame(
                        minWidth: 60,
                        maxWidth: 90
                    )
            } label: {
                Label("UI Dimming level", systemImage: "circle.lefthalf.striped.horizontal")
            }
            
            VStack(alignment: .leading) {
                
                Text("Select GPT model")
                    .padding(.bottom, 6)
                Picker("GPT model", selection: $pref.gptModel) {
                    ForEach(AIModel.allCases.reversed(), id: \.self) { model in
                        Text(model.name).tag(model.value)
                    }
                }
                .labelsHidden()
                .pickerStyle(SegmentedPickerStyle())
                
                Divider()
                    .padding(.vertical,20)
                
                Text("Adjust GPT temperature")
                    .padding(.bottom, 6)
                Slider(
                    value: $pref.gptTemperature,
                    in: 0.0...1.0,
                    step: 0.1
                )
                
                Divider()
                    .padding(.vertical,20)
                
                Text("Adjust UI scale")
                    .padding(.bottom, 6)
                
                HStack {
                    Image(systemName: "textformat.size.smaller")
                    Slider(
                        value: $pref.textScale,
                        in: 0.8...1.2,
                        step: 0.1
                    )
                    Image(systemName: "textformat.size.larger")
                    
                } // END HStack
            }
        }
    }
}

//
//  GeneralSettingsView.swift
//  Banksia
//
//  Created by Dave Coleman on 16/11/2023.
//

import SwiftUI
import SwiftData

struct GeneralSettingsView: View {
    @Environment(BanksiaHandler.self) private var bk
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        @Bindable var bk = bk
        
        VStack(alignment:.leading) {
            
            Text("Select GPT model")
                .padding(.bottom, 6)
            Picker("GPT model", selection: $bk.currentModel) {
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
                value: $bk.currentTemperature,
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
                    value: $bk.currentTextScale,
                    in: 0.8...1.2,
                    step: 0.1
                )
                Image(systemName: "textformat.size.larger")
                
            } // END HStack
        }
    }
}

#Preview {
    SettingsView()
        .environment(BanksiaHandler())
}

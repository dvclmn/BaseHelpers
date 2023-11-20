//
//  GeneralSettingsView.swift
//  Banksia
//
//  Created by Dave Coleman on 16/11/2023.
//

import SwiftUI

struct GeneralSettingsView: View {
    @EnvironmentObject var bk: BanksiaHandler
    var body: some View {
        VStack(alignment:.leading) {
            
            
            Text("Select GPT model")
                .fontStyle(.body)
                .padding(.bottom, 6)
            Picker("GPT model", selection: $bk.myModel) {
                ForEach(AIModel.allCases.reversed(), id: \.self) { model in
                    Text(model.name).tag(model.value)
                        .fontStyle(.body)
                }
            }
            .labelsHidden()
            .pickerStyle(SegmentedPickerStyle())
            
            Divider()
                .padding(.vertical,20)
            
            Text("Adjust GPT temperature")
                .fontStyle(.body)
                .padding(.bottom, 6)
            Slider(
                value: $bk.temperature,
                in: 0.0...1.0,
                step: 0.1
            )
            
            Divider()
                .padding(.vertical,20)
            
            Text("Adjust UI scale")
                .fontStyle(.body)
                .padding(.bottom, 6)
            
            HStack {
                Image(systemName: "textformat.size.smaller")
                    .fontStyle(.title2)
                Slider(
                    value: $bk.globalTextSize,
                    in: 0.8...1.2,
                    step: 0.1
                ).onChange(of: bk.globalTextSize) { oldValue, newValue in
                    print("UI scale value changed from \(oldValue) to: \(newValue)")
                }
                Image(systemName: "textformat.size.larger")
                    .fontStyle(.title2)
                
            } // END HStack
        }
    }
}

#Preview {
    SettingsView().environmentObject(BanksiaHandler())
}

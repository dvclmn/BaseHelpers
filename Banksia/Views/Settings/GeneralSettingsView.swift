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
        VStack {
            Slider(
                value: $bk.temperature,
                in: 0.0...1.0,
                step: 0.1
            )
            
            Picker("Model", selection: $bk.myModel) {
                ForEach(AIModel.allCases.reversed(), id: \.self) { model in
                    Text(model.name).tag(model.value)
                        .fontStyle(.body)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Label("Adjust UI scale", systemImage: "textformat.size")
                .fontStyle(.body)
                .padding(.bottom, 6)
            Text("Scale: \(bk.uiScale.description)")
                .padding(.bottom, 6)
                .fontStyle(.small)
            
            
            
            Slider(
                value: $bk.globalTextSize,
                in: 0.8...1.2,
                step: 0.1
            ).onChange(of: bk.globalTextSize) { oldValue, newValue in
                print("UI scale value changed from \(oldValue) to: \(newValue)")
            }
        }
    }
}

#Preview {
    GeneralSettingsView().environmentObject(BanksiaHandler())
}

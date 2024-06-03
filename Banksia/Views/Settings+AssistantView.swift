//
//  Settings+AssistantView.swift
//  Banksia
//
//  Created by Dave Coleman on 30/5/2024.
//

import SwiftUI
import Form
import Icons
import TextEditor
import MarkdownEditor


struct Settings_AssistantView: View {
    
    @EnvironmentObject var bk: BanksiaHandler
    
    @FocusState private var isEditorFocused
    
    var body: some View {
        Section("Customise AI") {
            
            LabeledContent {
                Text("\(bk.gptTemperature, specifier: "%.1f")")
                    .monospacedDigit()
                
                Slider(
                    value: $bk.gptTemperature,
                    in: 0.0...1.0,
                    step: 0.1
                )
                .frame(
                    minWidth: 80,
                    maxWidth: 140
                )
            } label: {
                Label("GPT Temperature", systemImage: Icons.snowflake.icon)
            }
            
            LabeledContent {
                
                Button {
                    bk.isEditingLongFormText.toggle()
                } label: {
                    Label("Edit", systemImage: Icons.edit.icon)
                }
                .buttonStyle(.customButton(size: .small))
                
            } label: {
                
                Label("System-wide prompt", systemImage: Icons.text.icon)
                Text("This will be included for each message in each conversation.")
            }
            
            Text(bk.systemPrompt)
                .multilineTextAlignment(.leading)
                .lineLimit(6)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            
            .sheet(isPresented: $bk.isEditingLongFormText) {

                TextEditorView(
                    text: bk.$systemPrompt,
                    isPresented: $bk.isEditingLongFormText) { text in
                        MarkdownEditorView(
                            text: text,
                            placeholderText: "Enter system prompt",
                            isFocused: $isEditorFocused
                        )
                        .focused($isEditorFocused)
                    }
            }
        }
    }
}

#Preview {
    Settings_AssistantView()
        .environmentObject(BanksiaHandler())
}

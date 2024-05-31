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
    @EnvironmentObject var pref: Preferences
    @EnvironmentObject var bk: BanksiaHandler
    
    @FocusState private var isEditorFocused
    
    var body: some View {
        Section("Customise AI") {
            FormLabel(
                label: "GPT Temperature",
                icon: Icons.snowflake.icon) {
                    Text("\(pref.gptTemperature, specifier: "%.1f")")
                        .monospacedDigit()
                    
                    Slider(
                        value: $pref.gptTemperature,
                        in: 0.0...1.0,
                        step: 0.1
                    )
                    .frame(
                        minWidth: 80,
                        maxWidth: 140
                    )
                }
            
            
            FormLabel(
                label: "System-wide prompt",
                icon: Icons.text.icon,
                message: "This will be included for each message in each conversation."
            ) {
                Text(pref.systemPrompt)
                    .multilineTextAlignment(.leading)
                    .lineLimit(6)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } content: {
                
                Button {
                    bk.isEditingLongFormText.toggle()
                } label: {
                    Label("Edit", systemImage: Icons.edit.icon)
                }
                .buttonStyle(.customButton(size: .small))
                
            }
            .sheet(isPresented: $bk.isEditingLongFormText) {

                TextEditorView(
                    text: pref.$systemPrompt,
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
}

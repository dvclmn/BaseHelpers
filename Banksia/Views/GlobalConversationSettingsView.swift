//
//  GlobalConversationSettingsView.swift
//  Banksia
//
//  Created by Dave Coleman on 16/4/2024.
//

import SwiftUI
import Styles
import Utilities

struct GlobalConversationSettingsView: View {
    @EnvironmentObject var pref: Preferences
    
    @State private var isEditingLongFormText: Bool = false
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                Text("Global Conversation preferences")
                    .font(.title)
                    .padding(.top)
                    .padding(.horizontal, Styles.paddingToMatchForm)
                    .padding(.bottom, -8)
                
                Form {
                    
                    FormLabel(label: "Name", icon: Icons.title.icon, message: "If you are comfortable doing so, provide your name here to personalise your assistants response.") {
                        TextField("", text: pref.$userName.boundString, prompt: Text("Enter your name"))
                            
                    }
                    
                    FormLabel(label: "System-wide prompt", icon: Icons.text.icon, message: "This will be included for each message in each conversation.") {
                        
                        VStack(alignment: .leading, spacing: 14) {
                            TextField("", text: pref.$systemPrompt, prompt: Text("System prompt"), axis: .vertical)
                                .multilineTextAlignment(.leading)
                                .lineLimit(4)
                            if !pref.systemPrompt.isEmpty {
                                Button {
                                    isEditingLongFormText.toggle()
                                } label: {
                                    Label("Expand", systemImage: Icons.expand.icon)
                                }
                                .labelBackground()

                            }
                        }
                        .padding(.top, 8)
                        
                    }
                    .onAppear {
                        if isPreview {
                            pref.systemPrompt = Message.prompt_01.content
                        }
                    }
                    .sheet(isPresented: $isEditingLongFormText) {
                        TextEditor(text: pref.$systemPrompt)
                    }
                    
                    
                    
                    
                } // END form
                .formStyle(.grouped)
            } // END main vstack
            .frame(maxWidth:.infinity, maxHeight:.infinity, alignment: .leading)
            .padding(Styles.paddingGenerous - Styles.paddingToMatchForm)
            
        } // END scroll view
        .scrollContentBackground(.hidden)
        .background(.contentBackground)
        //        .background(.ultraThinMaterial)
        .frame(minWidth: 340 , minHeight: 400)
    }
}

#Preview {
    GlobalConversationSettingsView()
        .environmentObject(Preferences())
        .frame(width: 380, height: 700)
    
}

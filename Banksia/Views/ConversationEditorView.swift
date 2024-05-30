//
//  ConversationEditorView.swift
//  Banksia
//
//  Created by Dave Coleman on 16/4/2024.
//

import SwiftUI
import GeneralStyles
import GeneralUtilities
import Grainient
import Modifiers
import Icons
import MarkdownEditor
import TextEditor

struct ConversationEditorView: View {
    @Environment(ConversationHandler.self) private var conv
    @EnvironmentObject var pref: Preferences
    
    @Bindable var conversation: Conversation
    
    @State private var isPromptEditorPresented: Bool = false
    @State private var localPromptValue: String = ""
    
    @FocusState private var isFocused
    
    var body: some View {
        
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                Text("Edit Conversation")
                    .font(.title)
                    .padding(.top)
                    .padding(.horizontal, Styles.paddingToMatchForm)
                    .padding(.bottom, -8)
                Form {
                    LabeledContent {
                        TextField("", text: $conversation.name, prompt: Text("Enter conversation name"))
                        
                    } label: {
                        Label("Conversation name", systemImage: Icons.title.icon)
                    }
                    
                    LabeledContent {
                        TextField("", text: $conversation.assistantName, prompt: Text("Customise how you address your assistant"))
                        
                    } label: {
                        Label("Assistant name", systemImage: Icons.person.icon)
                    }
                    
                    
                    LabeledContent {
                        Button {
                            isPromptEditorPresented = true
                        } label: {
                            Label("Edit prompt", systemImage: Icons.text.icon)
                        }
                        
                    } label: {
                        Label("Prompt", systemImage: Icons.text.icon)
                    }
                    .sheet(isPresented: $isPromptEditorPresented) {
                        TextEditorView(
                            text: $conversation.prompt.boundString,
                            isPresented: $isPromptEditorPresented
                        ) { text in
                            MarkdownEditorView(
                                text: text,
                                placeholderText: "Provide instructions to apply conversation-wide…",
                                isFocused: $isFocused
                            )
                                .focused($isFocused)
                        }
                    }
                    
                    LabeledContent {
                        Text("\(conversation.messages?.count ?? 0)")
                        
                    } label: {
                        Label("Messages", systemImage: Icons.message.icon)
                    }
                    
                    LabeledContent {
                        Text("\(conversation.tokens ?? 0)")
                        
                    } label: {
                        Label("Tokens used", systemImage: Icons.token.icon)
                    }
                    
                } // END form
                .formStyle(.grouped)
            } // END main vstack
            .frame(maxWidth:.infinity, maxHeight:.infinity, alignment: .leading)
            .padding(Styles.paddingGenerous - Styles.paddingToMatchForm)
            
        } // END scroll view
        .scrollContentBackground(.hidden)
                .background(.ultraThinMaterial)
        .frame(minWidth: 340 , minHeight: 400)
        .grainient(
            seed: conversation.grainientSeed,
            version: .v1
        )
    
    }
}

//#if DEBUG
//
//
//#Preview {
//    ConversationEditorView(conversation: Conversation.plants)
//        .environment(ConversationHandler())
//        .frame(width: 380)
//}
//
//
//#endif

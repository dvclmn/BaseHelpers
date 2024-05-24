//
//  ConversationEditorView.swift
//  Banksia
//
//  Created by Dave Coleman on 16/4/2024.
//

import SwiftUI
import Styles
import GeneralUtilities
import Grainient
import Modifiers
import Icons

struct ConversationEditorView: View {
    @Environment(ConversationHandler.self) private var conv
    
    @Bindable var conversation: Conversation
    
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
                        TextField("", text: $conversation.name, prompt: Text("Enter name"))
                        
                    } label: {
                        Label("Name", systemImage: Icons.title.icon)
                    }
                    
                    LabeledContent {
                        TextField("", text: $conversation.prompt.boundString, prompt: Text("Provide conversation-wide prompt"))
                        
                    } label: {
                        Label("Prompt", systemImage: Icons.text.icon)
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
        .grainient(seed: conversation.grainientSeed)
    
    }
}

#Preview {
    ConversationEditorView(conversation: Conversation.plants)
        .frame(width: 380)
}

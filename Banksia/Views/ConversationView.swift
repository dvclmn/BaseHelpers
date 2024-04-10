//
//  ConversationView.swift
//  Banksia
//
//  Created by Dave Coleman on 19/11/2023.
//

import SwiftUI
import SwiftData

struct ConversationView: View {
    @Environment(BanksiaHandler.self) private var bk
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        
        VStack {
            switch bk.conversationState {
            case .blank:
                ConversationStateView(
                    emoji: bk.conversationState.randomEmoji(),
                    title: bk.conversationState.randomTitle(),
                    message: bk.conversationState.randomMessage(),
                    actionLabel: "Create conversation",
                    actionIcon: "plus") {
                    bk.newConversation(for: modelContext)
                }
            case .none:
                ConversationStateView(
                    emoji: bk.conversationState.randomEmoji(),
                    title: bk.conversationState.randomTitle(),
                    message: bk.conversationState.randomMessage()
                )
            case .single:
                
                
                if let conversationID = bk.selectedConversations.first {
                    
                    let activeConversationPredicate = #Predicate<Conversation> { conversation in
                        
                            conversation.persistentModelID == conversationID
                    }
                    
                    MessagesView(filter: activeConversationPredicate)
                }
                
                
                
            case .multiple:
                ConversationStateView(
                    emoji: bk.conversationState.randomEmoji(),
                    title: bk.conversationState.randomTitle(),
                    message: bk.conversationState.randomMessage(),
                    actionLabel: "Delete conversations",
                    actionIcon: "trash"
                ) {
//                    bk.deleteConversations(bk.selectedConversations, modelContext: modelContext)
                }
            }
        } // END vstack
        
        
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        ContentView()
            .environment(BanksiaHandler())
    }
}

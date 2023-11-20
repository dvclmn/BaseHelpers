//
//  ConversationView.swift
//  Banksia
//
//  Created by Dave Coleman on 19/11/2023.
//

import SwiftUI
import SwiftData

struct ConversationView: View {
    @EnvironmentObject var bk: BanksiaHandler
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
                if let conversation = bk.currentConversations.first {
                    Text(conversation.name)
                }
            case .multiple:
                ConversationStateView(
                    emoji: bk.conversationState.randomEmoji(),
                    title: bk.conversationState.randomTitle(),
                    message: bk.conversationState.randomMessage(),
                    actionLabel: "Delete conversations",
                    actionIcon: "trash"
                ) {
                    bk.deleteConversations(bk.currentConversations, modelContext: modelContext)
                }
            }
        }
        
        
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        NavigationContentView()
            .environmentObject(BanksiaHandler())
    }
}

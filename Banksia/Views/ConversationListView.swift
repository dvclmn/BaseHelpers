//
//  ConversationListView.swift
//  Banksia
//
//  Created by Dave Coleman on 14/11/2023.
//

import SwiftUI
import SwiftData

struct ConversationListView: View {
    
    @Environment(BanksiaHandler.self) private var bk
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Conversation.name) private var conversations: [Conversation]
    
    var isDeleting: Bool
    
    var body: some View {
        @Bindable var bk = bk
        List(selection: $bk.currentConversation) {
            ForEach(conversations) { conversation in
                NavigationLink(conversation.name, value: conversation)
                    .contextMenu {
                        Button { bk.deleteConversation(conversation, modelContext: modelContext) } label: {
                            Label("Delete \(conversation.name)", systemImage: "trash")
                                .help("Delete the animal")
                        }
                    }
            }
        }
        .overlay {
            if conversations.isEmpty {
                ContentUnavailableView {
                    Label("No conversations", systemImage: "pawprint")
                } description: {
                    HandyButton(label: "New conversation", icon: "plus") {
                        bk.newConversation(for: modelContext)
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                HandyButton(label: "New conversation", icon: "plus") {
                    bk.newConversation(for: modelContext)
                }
            }
            
        }
    } // END view body
    
    private func removeConversations(at indexSet: IndexSet) {
        for index in indexSet {
            let conversationToDelete = conversations[index]
            if bk.currentConversation?.persistentModelID == conversationToDelete.persistentModelID {
                bk.currentConversation = nil
            }
            modelContext.delete(conversationToDelete)
        }
    } // END remove conversations
    
} // END view struct



#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        TwoColumnContentView()
            .environment(BanksiaHandler())
    }
}

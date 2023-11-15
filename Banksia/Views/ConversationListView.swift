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
    
    var body: some View {
        @Bindable var bk = bk
        List(selection: $bk.selectedConversation) {
            ForEach(conversations) { conversation in
                NavigationLink(conversation.name, value: conversation)
                    .contextMenu {
                        Button(action: {
                            
                        }){
                            Text("Delete")
                        }
                    }
            }
            .onDelete(perform: removeConversations)
        }
        .overlay {
            if conversations.isEmpty {
                ContentUnavailableView {
                    Label("No conversations", systemImage: "pawprint")
                } description: {
//                    AddConversationButton(isActive: $isEditorPresented)
                    Text("Add a button here")
                }
            }
        }
//        .toolbar {
//            ToolbarItem(placement: .primaryAction) {
//                AddConversationButton(isActive: $isEditorPresented)
//            }
//            
//        }
    }
    
    private func removeConversations(at indexSet: IndexSet) {
        for index in indexSet {
            let conversationToDelete = conversations[index]
            if bk.selectedConversation?.persistentModelID == conversationToDelete.persistentModelID {
                bk.selectedConversation = nil
            }
            modelContext.delete(conversationToDelete)
        }
    } // END remove conversations
    
}

//private struct AddConversationButton: View {
//    @Binding var isActive: Bool
//    
//    var body: some View {
//        Button {
//            isActive = true
//        } label: {
//            Label("Add a conversation", systemImage: "plus")
//                .help("Add a conversation")
//        }
//    }
//}

#Preview("ConversationListView") {
    ModelContainerPreview(ModelContainer.sample) {
        NavigationStack {
            ConversationListView().environment(BanksiaHandler())
        }
    }
}

#Preview("No selected conversation") {
    ModelContainerPreview(ModelContainer.sample) {
        ConversationListView().environment(BanksiaHandler())
    }
}

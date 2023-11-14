//
//  ConversationListView.swift
//  Banksia
//
//  Created by Dave Coleman on 14/11/2023.
//

import SwiftUI
import SwiftData

struct ConversationListView: View {
    
    @Environment(NavHandler.self) private var navHandler
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Conversation.name) private var conversations: [Conversation]
    @State private var isEditorPresented = false
    
    var body: some View {
        @Bindable var navHandler = navHandler
        List(selection: $navHandler.selectedConversation) {
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
        .sheet(isPresented: $isEditorPresented) {
            ConversationEditor(conversation: nil)
        }
        .overlay {
            if conversations.isEmpty {
                ContentUnavailableView {
                    Label("No conversations", systemImage: "pawprint")
                } description: {
                    AddConversationButton(isActive: $isEditorPresented)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                AddConversationButton(isActive: $isEditorPresented)
            }
        }
    }
    
    private func removeConversations(at indexSet: IndexSet) {
        for index in indexSet {
            let conversationToDelete = conversations[index]
            if navHandler.selectedConversation?.persistentModelID == conversationToDelete.persistentModelID {
                navHandler.selectedConversation = nil
            }
            modelContext.delete(conversationToDelete)
        }
    } // END remove conversations
}

private struct AddConversationButton: View {
    @Binding var isActive: Bool
    
    var body: some View {
        Button {
            isActive = true
        } label: {
            Label("Add an animal", systemImage: "plus")
                .help("Add an animal")
        }
    }
}

#Preview("ConversationListView") {
    ModelContainerPreview(ModelContainer.sample) {
        NavigationStack {
            ConversationListView()
                .environment(NavHandler())
        }
    }
}

#Preview("No selected conversation") {
    ModelContainerPreview(ModelContainer.sample) {
        ConversationListView()
    }
}

#Preview("AddConversationButton") {
    AddConversationButton(isActive: .constant(false))
}

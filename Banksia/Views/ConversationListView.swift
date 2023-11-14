/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A view that displays a list of animal categories.
*/

import SwiftUI
import SwiftData

struct ConversationListView: View {
    @Environment(NavHandler.self) private var navHandler
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Conversation.name) private var conversations: [Conversation]
    @State private var isReloadPresented = false

    var body: some View {
        @Bindable var navHandler = navHandler
        
        List(selection: $navHandler.selectedConversation) {
            ForEach(conversations) { conversation in
                NavigationLink(conversation.name, value: conversation)
            }
            .onDelete(perform: removeConversations)
            
        }
        .alert("Reload Sample Data?", isPresented: $isReloadPresented) {
            Button("Yes, reload sample data", role: .destructive) {
                reloadSampleData()
            }
        } message: {
            Text("Reloading the sample data deletes all changes to the current data.")
        }
        .overlay {
            if conversations.isEmpty {
                ContentUnavailableView {
                    Label("No animals in this category", systemImage: "pawprint")
                } description: {
                    Text("Add something")
                }
            }
        }
        .task {
            if conversations.isEmpty {
                Conversation.insertSampleData(modelContext: modelContext)
            }
        }
    }
    
    @MainActor
    private func reloadSampleData() {
        navHandler.selectedConversation = nil
        navHandler.selectedAnimalCategoryName = nil
        Conversation.reloadSampleData(modelContext: modelContext)
    }
    private func removeConversations(at indexSet: IndexSet) {
        for index in indexSet {
            let conversationToDelete = conversations[index]
            if navHandler.selectedConversation?.persistentModelID == conversationToDelete.persistentModelID {
                navHandler.selectedConversation = nil
            }
            modelContext.delete(conversationToDelete)
        }
    }
    
}

private struct AddConversationButton: View {
    @Binding var isActive: Bool
    
    var body: some View {
        Button {
            isActive = true
        } label: {
            Label("Add a conversation", systemImage: "plus")
                .help("Add a conversation")
        }
    }
}

private struct ListConversations: View {
    var conversations: [Conversation]
    
    var body: some View {
        ForEach(conversations) { conversation in
            NavigationLink(conversation.name, value: conversation.name)
        }
    }
}

#Preview("AnimalCategoryListView") {
    ModelContainerPreview(ModelContainer.sample) {
        NavigationStack {
            ConversationListView()
        }
        .environment(NavHandler())
    }
}

#Preview("ListCategories") {
    ModelContainerPreview(ModelContainer.sample) {
        NavigationStack {
            List {
                ListConversations(conversations: [.plants, .childcare, .appKitDrawing] )
            }
        }
        .environment(NavHandler())
    }
}

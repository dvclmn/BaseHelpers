//
//  ContentView.swift
//  Banksia
//
//  Created by Dave Coleman on 13/11/2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query var conversations: [Conversation]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(conversations) { conversation in
                    NavigationLink {
                        Text("Conversation at \(conversation.created, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(conversation.name)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
            .toolbar {
                ToolbarItem {
                    Button(action: addConversation) {
                        Label("New conversation", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addConversation() {
        withAnimation {
            let newConversation = Conversation(name: "New conversation")
            modelContext.insert(newConversation)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(conversations[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(PreviewSampleData.container)
}

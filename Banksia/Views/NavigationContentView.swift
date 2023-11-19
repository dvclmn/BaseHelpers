//
//  NavigationContentView.swift
//  Banksia
//
//  Created by Dave Coleman on 19/11/2023.
//

import SwiftUI
import SwiftData

struct NavigationContentView: View {
    @EnvironmentObject var bk: BanksiaHandler
    @Environment(\.modelContext) private var modelContext
    @Environment(\.undoManager) var undoManager
    @Query(sort: \Conversation.name) private var conversations: [Conversation]
    
    var body: some View {
        NavigationSplitView(columnVisibility: $bk.sidebarVisibility) {
            List(selection: $bk.currentConversations) {
                ForEach(conversations) { conversation in
                    ConversationListItem(conversation: conversation)
                } // END foreach
            } // END list
            .navigationTitle("Conversations")
            .navigationSplitViewColumnWidth(min: 180, ideal: 220, max: 260)
            .overlay {
                if conversations.isEmpty {
                    ContentUnavailableView {
                        Label("Time to start a new conversation", systemImage: "message")
                    } description: {
                        HandyButton(label: "Add conversation", icon: "plus") {
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
        } detail: {
            ConversationView()
        }
        .toolbar {
            ToolbarItem() {
                Circle()
                    .fill(Color.random)
                    .frame(width:8, height:8)
                    .padding(8)
            } // view changed tester
            
            ToolbarItem() {
                HandyButton(label: "Add sample data", icon: "sparkles") {
                    Conversation.insertSampleData(modelContext: modelContext)
                    try? modelContext.save()
                }
            } // END add sample data
            
        } // END toolbar
        
        
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        NavigationContentView()
            .environmentObject(BanksiaHandler())
    }
}

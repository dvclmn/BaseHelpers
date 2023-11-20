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
            .navigationSplitViewColumnWidth(min: 200, ideal: 260, max: 320)
            .onAppear(perform: {
                bk.totalConversations = conversations.count
            })
            .onChange(of: conversations.count, {
                bk.totalConversations = conversations.count
            })
            // Sidebar toolbar
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
        // Detail view toolbar
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
            
            ToolbarItem() {
                switch bk.conversationState {
                case .blank:
                    EmptyView()
                case .none:
                    EmptyView()
                case .single:
                    if let conversation = bk.currentConversations.first {
                        HandyButton(label: "Delete \(conversation.name)", icon: "trash") {
                            bk.deleteConversations([conversation], modelContext: modelContext)
                        }                        
                    }
                case .multiple:
                    HandyButton(label: "Delete all conversations", icon: "trash.fill") {
                        bk.deleteConversations(bk.currentConversations, modelContext: modelContext)
                    }
                }
                
            } // END delete
            
        } // END toolbar
        
        
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        NavigationContentView()
            .environmentObject(BanksiaHandler())
    }
}

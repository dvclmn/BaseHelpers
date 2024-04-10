//
//  NavigationContentView.swift
//  Banksia
//
//  Created by Dave Coleman on 19/11/2023.
//

import SwiftUI
import SwiftData

struct NavigationContentView: View {
    @Environment(BanksiaHandler.self) private var bk
    @Environment(\.modelContext) var modelContext
    @Environment(\.undoManager) var undoManager
    @Query(sort: \Conversation.created) private var conversations: [Conversation]
    
    var body: some View {
        
        @Bindable var bk = bk
        
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
                HandyButton(label: "Add sample data", icon: "sparkles") {
                    Conversation.insertSampleData(modelContext: modelContext)
                    try? modelContext.save()
                }
            } // END add sample data
            
            ToolbarItem() {
                switch bk.conversationState {
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
                default:
                    EmptyView()
                }
                
            } // END delete
            
        } // END toolbar
        .onAppear {
            if let firstConversation = conversations.first {
                bk.currentConversations = [firstConversation]
            }
        }
        
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        NavigationContentView()
            .environment(BanksiaHandler())
            .frame(width: 600, height: 700)
        
    }
}

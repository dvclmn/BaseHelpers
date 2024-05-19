//
//  ContentView.swift
//  Banksia
//
//  Created by Dave Coleman on 14/11/2023.
//

import SwiftUI
import SwiftData
import Utilities
import Grainient
import SplitView

struct ContentView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.undoManager) var undoManager
    @Environment(BanksiaHandler.self) private var bk
    @Environment(ConversationHandler.self) private var conv
    
    @Query(sort: \Conversation.created) private var conversations: [Conversation]
    
    var body: some View {
        
        @Bindable var bk = bk
        
        
        SplitView {
            SidebarView(conversations: conversations)
        } content: {
            ZStack {
                
                if let currentConversation = conversations.first(where: {$0.id == bk.selectedConversation}) {
                    
                    @Bindable var currentConversation = currentConversation
                    
                    ConversationView(conversation: currentConversation)
                        .navigationTitle(currentConversation.name)
                }
                
                
                if bk.isQuickNavShowing {
                    QuickNavView()
                }
                
            }
//            .onAppear {
//                if isPreview {
//                    bk.isQuickNavShowing = true
//                }
//            }
        }

        .onChange(of: conv.isRequestingNewConversation) {
            let newConversation = Conversation()
            modelContext.insert(newConversation)
            bk.selectedConversation = newConversation.persistentModelID
        }
        .onAppear {
            if let firstConversation = conversations.first {
                bk.selectedConversation = firstConversation.persistentModelID
            }
//            getActiveConversation()
        }
        .onChange(of: bk.selectedConversation) {
//            getActiveConversation()
        }
        .grainient(seed: 985247)
//        .background(.contentBackground)
        
    }
    
//    private func getActiveConversation() {
//        print("Let's get the active conversation")
//        if let conversationID = bk.selectedConversation.first {
//            let conversation = conversations.first(where: {$0.persistentModelID == conversationID})
//            print("The active conversation is: \(String(describing: conversation?.name))")
//            bk.activeConversation = conversation
//        }
//    }
}

#Preview {
    ContentView()
        .environment(ConversationHandler())
        .environment(BanksiaHandler())
        .environmentObject(Preferences())
        .modelContainer(try! ModelContainer.sample())
        .frame(width: 600, height: 700)
}

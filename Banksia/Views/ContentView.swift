//
//  ContentView.swift
//  Banksia
//
//  Created by Dave Coleman on 14/11/2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.undoManager) var undoManager
    @Environment(BanksiaHandler.self) private var bk
    
    @Query(sort: \Conversation.created) private var conversations: [Conversation]
    
    
    
    var body: some View {
        
        @Bindable var bk = bk
        
        NavigationSplitView(columnVisibility: $bk.sidebarVisibility) {
            
            SidebarView(conversations: conversations)
            
        } detail: {
            
            if let conversationID = bk.selectedConversations.first {
                
                let activeConversationPredicate = #Predicate<Conversation> { conversation in
                    
                    conversation.persistentModelID == conversationID
                }
                
                ConversationView(filter: activeConversationPredicate)
            }
            
            
            
            
            
            
        }
        // Detail view toolbar
        .toolbar {
            ToolbarView()
            
        } // END toolbar
        .onAppear {
            if let firstConversation = conversations.first {
                bk.selectedConversations = [firstConversation.persistentModelID]
            }
//            getActiveConversation()
        }
        .onChange(of: bk.selectedConversations) {
//            getActiveConversation()
        }
        .background(.contentBackground)
        
    }
    
//    private func getActiveConversation() {
//        print("Let's get the active conversation")
//        if let conversationID = bk.selectedConversations.first {
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

//
//  DetailView.swift
//  Banksia
//
//  Created by Dave Coleman on 23/5/2024.
//

import SwiftUI
//import Navigation
//import Popup
//import Sidebar
//import SwiftData

struct DetailView: View {
    
    var page: Page? = nil
    var conversations: [Conversation]
    
    var body: some View {
        
        switch page {
        case .conversation(let conversationStatic):
            if let conversation = conversations.first(where: {$0.persistentModelID == conversationStatic.persistentModelID}) {
                
                HStack(spacing: 0) {
                    SidebarView()
                    
                    VStack {
                        ConversationView(conversation: conversation)
                    }
                    
                } // END hstack
                
                
                .overlay(alignment: .top) {
                    ToolbarView(conversation: conversation)
                }
                .navigationBarBackButtonHidden(true)
                
            } else {
                Text("No conversation")
            }
            
        case .none:
            Text("No page")
        }

    }
}

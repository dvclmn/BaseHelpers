//
//  SidebarView.swift
//  Banksia
//
//  Created by Dave Coleman on 10/4/2024.
//

import SwiftUI

struct SidebarView: View {
    
    @Environment(BanksiaHandler.self) private var bk
    @Environment(\.modelContext) var modelContext
    
    var conversations: [Conversation]
    
    var body: some View {
        
        @Bindable var bk = bk
        
        List(selection: $bk.selectedConversations) {
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

                Button {
                    bk.newConversation(for: modelContext)
                } label: {
                    Label("New conversation", systemImage: Icons.plus.icon)
                }
            }
        }
    }
}

#Preview {
    NavigationSplitView {
        SidebarView(conversations: [Conversation.appKitDrawing, Conversation.childcare])
            .environment(BanksiaHandler())
    } detail: {
        ConversationView()
    }
}

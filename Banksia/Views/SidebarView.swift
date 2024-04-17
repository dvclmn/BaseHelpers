//
//  SidebarView.swift
//  Banksia
//
//  Created by Dave Coleman on 10/4/2024.
//

import SwiftUI
import Styles

struct SidebarView: View {
    
    @Environment(BanksiaHandler.self) private var bk
    @Environment(\.modelContext) var modelContext
    
    var conversations: [Conversation]
    
    var body: some View {
        
        @Bindable var bk = bk
        
        VStack {
            List(selection: $bk.selectedConversation) {
                ForEach(conversations) { conversation in
                    ConversationListItem(conversation: conversation)
                } // END foreach
            } // END list
            .navigationTitle("Conversations")
            .navigationSplitViewColumnWidth(min: 200, ideal: 260, max: 320)
            .toolbar {
                ToolbarItem {
                    Button {
                        bk.newConversation(for: modelContext)
                    } label: {
                        Label("New conversation", systemImage: Icons.plus.icon)
                    }
                }
                
                ToolbarItem {
                    Button {
                        bk.isGlobalConversationPreferencesShowing.toggle()
                    } label: {
                        Label("App-wide conversation preferences", systemImage: Icons.sliders.icon)
                    }
                    
                    
                }
            } // END toolbar
        } // END vstack
        .onAppear(perform: {
            bk.totalConversations = conversations.count
        })
        .onChange(of: conversations.count, {
            bk.totalConversations = conversations.count
        })
        
    }
}

#Preview {
    NavigationSplitView {
        SidebarView(conversations: [Conversation.appKitDrawing, Conversation.childcare])
    } detail: {
        ConversationView(conversation: Conversation.appKitDrawing)
    }
    .environment(BanksiaHandler())
    .environment(ConversationHandler())
}

//
//  SidebarView.swift
//  Banksia
//
//  Created by Dave Coleman on 10/4/2024.
//

import SwiftUI
import SwiftData
import Styles
import SplitView
import Sidebar
import Navigation

struct SidebarView: View {
    @Environment(BanksiaHandler.self) private var bk
    @Environment(ConversationHandler.self) private var conv
    @EnvironmentObject var sidebar: SidebarHandler
    @EnvironmentObject var nav: NavigationHandler<Page>
    
    @Environment(\.modelContext) var modelContext
    
    @Query(sort: \Conversation.created, order: .reverse) private var conversations: [Conversation]
    
    
    
    var body: some View {
        
        @Bindable var bk = bk
        
        
        CustomSidebar(sidebar: sidebar) {
            
            
                        
            
            ForEach(conversations) { conversation in
                ConversationListItem(
                    page: Page.conversation(conversation),
                    conversation: conversation
                )
            } // END foreach
        } // END sidebar
        .onAppear {
            if nav.path.isEmpty, let firstConversation = conversations.first {
                nav.path = [Page.conversation(firstConversation)]
            }
        }
    }
}
//
//#Preview {
//    NavigationSplitView {
//        SidebarView(conversations: [Conversation.appKitDrawing, Conversation.childcare])
//    } detail: {
//        ConversationView(conversation: Conversation.appKitDrawing)
//    }
//    .environment(BanksiaHandler())
//    .environment(ConversationHandler())
//}

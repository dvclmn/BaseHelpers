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

struct SidebarView: View {
    @Environment(BanksiaHandler.self) private var bk
    @Environment(ConversationHandler.self) private var conv
    @EnvironmentObject var sidebar: SidebarHandler
    
    @Environment(\.modelContext) var modelContext
    
    @Query(sort: \Conversation.created) private var conversations: [Conversation]
    
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

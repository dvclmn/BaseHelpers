//
//  SidebarView.swift
//  Banksia
//
//  Created by Dave Coleman on 10/4/2024.
//

import SwiftUI
import SwiftData
import GeneralStyles
import Sidebar
import Navigation

struct SidebarView: View {
    @Environment(BanksiaHandler.self) private var bk
    @Environment(ConversationHandler.self) private var conv
    @EnvironmentObject var sidebar: SidebarHandler
    @EnvironmentObject var nav: NavigationHandler
    
    @Environment(\.modelContext) var modelContext
    
    @Query(sort: \Conversation.created, order: .reverse) private var conversations: [Conversation]
    
    var body: some View {
        
        @Bindable var bk = bk
        
        if sidebar.isSidebarVisible {
            
            //            ResizableView(
            //                size: $sidebar.sidebarWidth,
            //                minSize: 90,
            //                maxSize: 240,
            //                edge: .leading) {
            VStack(alignment: .leading) {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 2) {
                        ForEach(conversations) { conversation in
                            ConversationListItem(
                                page: Page.conversation(conversation),
                                conversation: conversation
                            )
                        } // END foreach
                    }
                    .padding(SidebarHandler.sidebarPadding)
                }
                Spacer()
            }
            //                }
            .background(.black.opacity(0.35))
            .background(.regularMaterial)
            .safeAreaPadding(.top, Styles.toolbarHeight)
            .transition(.move(edge: .leading))
            .frame(width: sidebar.sidebarWidth, alignment: .leading)
            
        } // END sidebar check
        
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

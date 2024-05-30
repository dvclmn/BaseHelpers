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
import Button

struct SidebarView: View {
    @EnvironmentObject var bk: BanksiaHandler
    @Environment(ConversationHandler.self) private var conv
    @EnvironmentObject var sidebar: SidebarHandler
    @EnvironmentObject var nav: NavigationHandler
    
    @Environment(\.modelContext) var modelContext
    
    @Query(sort: \Conversation.created, order: .reverse) private var conversations: [Conversation]
    
    var body: some View {
        
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
                

                NavigationLink(value: Page.feedback) {
                    
                    Label("Feedback", systemImage: "horn.blast")
                        .frame(maxWidth: .infinity, alignment: .leading)
                } // END nav link
                .padding(SidebarHandler.sidebarPadding)
                .symbolRenderingMode(.hierarchical)
                .symbolVariant(.fill)
                .buttonStyle(.customButton(status: Page.feedback == nav.path.last ? .active : .normal, hasBackground: false))

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
//    .environmentObject(BanksiaHandler())
//    .environment(ConversationHandler())
//}

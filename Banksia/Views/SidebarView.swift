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
import Icons

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
                    LazyVStack(spacing: 6) {
                        ForEach(conversations) { conversation in
                            ConversationListItem(
                                page: Page.conversation(conversation),
                                conversation: conversation
                            )
                        } // END foreach
                    }
                    .padding(Styles.paddingGutter)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    
                        
                        SidebarButton(
                            label: Page.feedback.name,
                            icon: Page.feedback.icon,
                            nav: nav,
                            page: Page.feedback
                        )
                        
                        
                        SidebarButton(
                            label: Page.settings.name,
                            icon: Page.settings.icon,
                            nav: nav,
                            page: Page.settings,
                            isSettingsLink: true
                        )
                        

                    
                        Label("Banksia v\(bk.getAppVersion())-beta", systemImage: Icons.shocked.icon)
                    
                    .labelStyle(.customLabel(size: .mini, labelDisplay: .titleOnly))
                    .opacity(0.4)
                    .symbolVariant(.fill)
                    .padding(.leading, 10)
                    .padding(.bottom, 5)
                } // END vstack
                .padding(Styles.paddingGutter)
                
                
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

#Preview {
    SidebarView()
        .environment(ConversationHandler())
        .environmentObject(BanksiaHandler())
        .environmentObject(SidebarHandler())
        .environmentObject(NavigationHandler())
    
        .frame(width: 200, height: 600)
}


//public struct SidebarButtonModifier: ViewModifier {
//
//    var page:
//    var isActive: Bool
//
//    public func body(content: Content) -> some View {
//        content
//
//    }
//}
//extension View {
//    func sidebarButton(
//        isActive: Bool = false
//    ) -> some View {
//        self.modifier(
//            SidebarButtonModifier(
//                isActive: isActive
//            )
//        )
//    }
//}
//





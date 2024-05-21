//
//  ConversationListItem.swift
//  Banksia
//
//  Created by Dave Coleman on 19/11/2023.
//

import SwiftUI
import Styles
import Navigation
import Popup
import BaseUIElement
import Sidebar

struct ConversationListItem: View {
    @Environment(\.modelContext) private var modelContext
    
    @EnvironmentObject var nav: NavigationHandler<Page>
    @Environment(BanksiaHandler.self) private var bk
    @Environment(ConversationHandler.self) private var conv
    
    @EnvironmentObject var sidebar: SidebarHandler
    @EnvironmentObject var popup: PopupHandler
    
    @State private var iconPickerShowing: Bool = false
    
    var page: Page
    @Bindable var conversation: Conversation
    
    var body: some View {
        
        var isCurrentPage: Bool {
            return page == nav.path.last
        }
        
        SidebarButton(
            page: page,
            label: page.name,
            editableLabel: $conversation.name,
            icon: "bubble.middle.bottom",
            isCurrentPage: isCurrentPage,
            isEditable: true
        ) {
            Button {
                do {
                    modelContext.delete(conversation)
                    try modelContext.save()
                    
                    popup.showPopup(title: "Deleted \(conversation.name)")
                } catch {
                    
                    print("Could not save")
                }
            } label: {
                Label("Delete conversation", systemImage: Icons.trash.icon)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
        
        
        
    }
}

#Preview {
    ConversationListItem(page: .conversation(Conversation.appKitDrawing), conversation: Conversation.appKitDrawing)
        .environment(BanksiaHandler())
        .environmentObject(PopupHandler())
}

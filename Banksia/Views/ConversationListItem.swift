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
    
    @Environment(Navigation<Page>.self) private var nav
    @Environment(BanksiaHandler.self) private var bk
    @Environment(ConversationHandler.self) private var conv
    
    @EnvironmentObject var sidebar: SidebarHandler
    @EnvironmentObject var popup: PopupHandler
    
    @FocusState private var isFieldFocused: Bool
    
    @State private var isRenaming: Bool = false
    
    @State private var oldName: String = ""
    @State private var newName: String = ""
    
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
            isEditable: true,
            isRenaming: $isRenaming
        )
        .frame(maxWidth: .infinity, alignment: .leading)
        
        .contextMenu {
            Button {
                isRenaming = true
            } label: {
                Label("Rename", systemImage: Icons.text.icon)
            }
            Button {
                do {
                    modelContext.delete(conversation)
                    try modelContext.save()
                    
                    popup.showPopup(title: "Deleted \(conversation.name)")
                } catch {
                    
                    print("Could not save")
                }
            } label: {
                Label("Delete game", systemImage: Icons.trash.icon)
            }
        } // END context menu
        
        
    }
}

#Preview {
    ConversationListItem(page: .conversation(Conversation.appKitDrawing), conversation: Conversation.appKitDrawing)
        .environment(BanksiaHandler())
        .environmentObject(PopupHandler())
}

//
//  ConversationListItem.swift
//  Banksia
//
//  Created by Dave Coleman on 19/11/2023.
//

import SwiftUI
import GeneralStyles
import Navigation
import Popup
import Sidebar
import Button
import Icons
import MultiSelect
import Renamable

struct ConversationListItem: View {
    @Environment(\.modelContext) private var modelContext
    
    @EnvironmentObject var nav: NavigationHandler
    @EnvironmentObject var bk: BanksiaHandler
    @EnvironmentObject var conv: ConversationHandler
    
    @EnvironmentObject var sidebar: SidebarHandler
    @EnvironmentObject var popup: PopupHandler
    
    @State private var iconPickerShowing: Bool = false
    
    @State private var isRenaming: Bool = false
    
    var page: Page
    
    @Bindable var conversation: Conversation
    
    var body: some View {
        
        SidebarButton(
            label: page.name,
            icon: "bubble.middle.bottom",
            nav: nav,
            page: page
        )
            .renamable(
                isRenaming: $isRenaming,
                itemName: conversation.name,
                renameAction: { newName in
                    conversation.name = newName
                    popup.showPopup(title: "Renamed to \"\(conversation.name)\"")
                })
        
        
            .contextMenu {
                Button {
                    isRenaming = true
                } label: {
                    Label("Rename…", systemImage: Icons.select.icon)
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
                    Label("Delete conversation", systemImage: Icons.trash.icon)
                }
                
            } // END context menu
    }
}
//
//#Preview {
//    ConversationListItem(page: .conversation(Conversation.appKitDrawing), conversation: Conversation.appKitDrawing)
//        .environmentObject(BanksiaHandler())
//        .environmentObject(PopupHandler())
//}

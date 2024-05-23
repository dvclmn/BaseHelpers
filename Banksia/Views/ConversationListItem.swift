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
import Sidebar
import Button
import Icons

struct ConversationListItem: View {
    @Environment(\.modelContext) private var modelContext
    
    @EnvironmentObject var nav: NavigationHandler<Page>
    @Environment(BanksiaHandler.self) private var bk
    @Environment(ConversationHandler.self) private var conv
    
    @EnvironmentObject var sidebar: SidebarHandler
    @EnvironmentObject var popup: PopupHandler
    
    @State private var iconPickerShowing: Bool = false
    
    @State private var isRenaming: Bool = false
    
    var page: Page
    
    @Bindable var conversation: Conversation
    
    var body: some View {
        
        var isCurrentPage: Bool {
            return page == nav.path.last
        }

        
        
        NavigationLink(value: page) {
            Label(page.name, systemImage: "bubble.middle.bottom")
                .renamable(
                    isRenaming: $isRenaming,
                    itemName: conversation.name,
                    renameAction: { newName in
                        conversation.name = newName
                    popup.showPopup(title: "Renamed to \"\(conversation.name)\"")
                })
        } // END nav link
        .symbolRenderingMode(.hierarchical)
        .symbolVariant(.fill)
        .buttonStyle(.customButton(status: isCurrentPage ? .active : .normal, hasBackground: false))
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

        .frame(maxWidth: .infinity, alignment: .leading)
        
    }
}

#Preview {
    ConversationListItem(page: .conversation(Conversation.appKitDrawing), conversation: Conversation.appKitDrawing)
        .environment(BanksiaHandler())
        .environmentObject(PopupHandler())
}

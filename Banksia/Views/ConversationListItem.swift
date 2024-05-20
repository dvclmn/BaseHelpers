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

struct ConversationListItem: View {
    @Environment(BanksiaHandler.self) private var bk
    @Environment(ConversationHandler.self) private var conv
    @EnvironmentObject var popup: PopupHandler
    @Environment(\.modelContext) private var modelContext
    
    @FocusState private var isFieldFocused: Bool
    @State private var oldName: String = ""
    @State private var newName: String = ""
    
    @State private var iconPickerShowing: Bool = false
    
    var page: Page
    @Bindable var conversation: Conversation
    
    var body: some View {
        
            NavigationLink(value: page) {
                Text(page.name)
                         
            } // END navigation link
            .contextMenu {
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
            }
        
    }
}

#Preview {
    ConversationListItem(page: .conversation(Conversation.appKitDrawing), conversation: Conversation.appKitDrawing)
        .environment(BanksiaHandler())
        .environmentObject(PopupHandler())
}

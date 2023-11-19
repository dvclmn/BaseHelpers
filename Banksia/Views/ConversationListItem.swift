//
//  ConversationListItem.swift
//  Banksia
//
//  Created by Dave Coleman on 19/11/2023.
//

import SwiftUI

struct ConversationListItem: View {
    @EnvironmentObject var bk: BanksiaHandler
    @Environment(\.modelContext) private var modelContext
    
    @FocusState private var isFieldFocused: Bool
    @State private var oldName: String = ""
    @State private var newName: String = ""
    
    @Bindable var conversation: Conversation
    var body: some View {
        NavigationLink(value: conversation) {
            TextField("Conversation name", text: $conversation.name)
                .focused($isFieldFocused)
                .onChange(of: isFieldFocused) {
                    if conversation.name.isEmpty {
                        conversation.name = oldName
                        print("No empty layer names allowed! Name set back to '\(oldName)'")
                    } else {
                        if isFieldFocused {
                            oldName = conversation.name
                        } // END is name field focused
                    } // END if layer name empty
                } // END onChange of: field focused
        } // END navigation link
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                modelContext.delete(conversation)
                bk.currentConversations = []
                do {
                    try modelContext.save()
                } catch {
                    print(error.localizedDescription)
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
        } // END swipe actions
    }
}

#Preview {
    ConversationListItem(conversation: .plants)
}

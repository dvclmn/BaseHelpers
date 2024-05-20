//
//  ToolbarView.swift
//  Banksia
//
//  Created by Dave Coleman on 10/4/2024.
//

import SwiftUI
import Styles
import Navigation

struct ToolbarView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(BanksiaHandler.self) private var bk
    @Environment(Navigation.self) private var nav
    
    var body: some View {
        
        Button {
            let newConversation = Conversation(name: "New conversation")
            modelContext.insert(newConversation)
            nav.path.append(Page.conversation(newConversation))
            
        } label: {
            Label("New conversation", systemImage: Icons.plus.icon)
        }
//            HandyButton(label: "Add sample data", icon: "sparkles") {
//                Conversation.insertSampleData(modelContext: modelContext)
//                try? modelContext.save()
//            }
        
        
//        ToolbarItem() {
//            switch bk.conversationState {
//            case .single:
//                if let conversation = bk.selectedConversation.first {
//                    HandyButton(label: "Delete \(conversation.name)", icon: "trash") {
//                        bk.deleteConversations([conversation], modelContext: modelContext)
//                    }
//                }
//            case .multiple:
//                HandyButton(label: "Delete all conversations", icon: "trash.fill") {
//                    bk.deleteConversations(bk.selectedConversation, modelContext: modelContext)
//                }
//            default:
//                EmptyView()
//            }
            
//        } // END delete
    }
}

#Preview {
    ContentView()
        .environment(BanksiaHandler())
}

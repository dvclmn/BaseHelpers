//
//  ToolbarView.swift
//  Banksia
//
//  Created by Dave Coleman on 10/4/2024.
//

import SwiftUI

struct ToolbarView: ToolbarContent {
    @Environment(\.modelContext) var modelContext
    @Environment(BanksiaHandler.self) private var bk
    
    var body: some ToolbarContent {
        ToolbarItem() {
            HandyButton(label: "Add sample data", icon: "sparkles") {
                Conversation.insertSampleData(modelContext: modelContext)
                try? modelContext.save()
            }
        } // END add sample data
        
//        ToolbarItem() {
//            switch bk.conversationState {
//            case .single:
//                if let conversation = bk.selectedConversations.first {
//                    HandyButton(label: "Delete \(conversation.name)", icon: "trash") {
//                        bk.deleteConversations([conversation], modelContext: modelContext)
//                    }
//                }
//            case .multiple:
//                HandyButton(label: "Delete all conversations", icon: "trash.fill") {
//                    bk.deleteConversations(bk.selectedConversations, modelContext: modelContext)
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

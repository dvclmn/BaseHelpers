//
//  ConversationHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 15/11/2023.
//

import Foundation
import SwiftUI
import SwiftData

//class ConversationHandler {
//    
//    let bk = BanksiaHandler()
//    
//    static let activeConversationPredicate: Predicate<Conversation> = #Predicate<Conversation> {
//        if let conversationID = bk.selectedConversations.first {
//            
//        }
//    }
//}

enum ConversationState {
    case blank
    case none
    case single
    case multiple

    init(totalConversations: Int, selectedConversations: Set<Conversation.ID>) {
        if totalConversations == 0 {
            self = .blank
        } else {
            switch selectedConversations.count {
            case 0:
                self = .none
            case 1:
                self = .single
            default:
                self = .multiple
            }
        } // END empty conversations check
    } // END init
    
    var emoji: [String] {
        switch self {
        case .blank:
            return ["🕸️", "🎃", "🌴", "🌵"]
        case .none:
            return ["🫧", "👠", "🪨", "🪸", "🕳️"]
        case .single:
            return []
        case .multiple:
            return ["💃", "🪶", "🐝", "🍌", "🦎"]
        }
    } // END emoji
    
    var title: [String] {
        switch self {
        case .blank:
            return [
                "Begin a new conversation",
                "Time to start a chat",
                "No conversations here"
            ]
        case .none:
            return [
                "Nothing selected",
                "No conversations selected",
                "Select a conversation"
            ]
        case .single:
            return []
        case .multiple:
            return [
                "Multiple conversations",
                "Multiple chats selected",
                "A few conversations selected"
            ]
        }
    } // END title
    
    var message: [String] {
        switch self {
        case .blank:
            return [
                "You have no conversations. Create a new one to get started.",
                "It's as good a time as any to create a conversation."
            ]
        case .none:
            return [
                "Make a selection from the list in the sidebar.",
                "You can pick something from the sidebar on the left."
            ]
        case .single:
            return []
        case .multiple:
            return [
                "You can delete them, or select other options from the toolbar above."
            ]
        }
    } // END title
    
    func randomEmoji() -> String {
        self.emoji.randomElement() ?? ""
    }
    func randomTitle() -> String {
        self.title.randomElement() ?? ""
    }
    func randomMessage() -> String {
        self.message.randomElement() ?? ""
    }
    
} // END coversation state


extension BanksiaHandler {
    
    func newConversation(for modelContext: ModelContext) {

        let newConversation = Conversation(name: "New conversation")
        
        modelContext.insert(newConversation)
        
        do {
            try modelContext.save()

        } catch {
            print("Failed to save new conversation: \(error)")
        }
        selectedConversations = []
        selectedConversations = [newConversation.persistentModelID]
    }
    
    func deleteConversations(_ conversations: Set<Conversation>, modelContext: ModelContext) {
        selectedConversations = []
        for conversation in conversations {
            modelContext.delete(conversation)
        }
    }
    
    func deleteAll(for modelContext: ModelContext) {
        selectedConversations = []
        do {
            try modelContext.delete(model: Conversation.self)
        } catch {
            print("Failed to clear Conversations.")
        }
    } // END delete all

    

} // END BanksiaHandler extension

//
//  ConversationHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 15/11/2023.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
final class ConversationHandler {
    
    let bk = BanksiaHandler()
    let pref = Preferences()
    
    var searchText: String = ""
    var isSearching: Bool = false
    
    var messageHistory: String = ""
    
    var isResponseLoading: Bool = false
    
    func createMessageHistory(for conversation: Conversation) async {
        
        guard let messages = conversation.messages, !messages.isEmpty else {
            messageHistory = ""
            print("No message in conversation")
            return
        }
        
        let maxMessageContextCount: Int = 6
        let latestQueryDecorator: String = "Latest Query:\n"
        let conversationHistoryDecorator: String = "Conversation History:\n"
        
        guard messages.count > 1 else {
            let singleMessage = messages[0].content
            messageHistory = latestQueryDecorator + singleMessage
            print("Only single message in conversation: \(messageHistory)")
            return
        }
        
        let contextMessages: [Message] = messages.suffix(maxMessageContextCount + 1)
        messageHistory = messages.map { $0.content }.joined(separator: "\n")
        
        let historicalContext = contextMessages
            .dropLast()
            .map { $0.content }
            .joined(separator: "\n")
        
        /// Special formatting for the most recent message
        if let mostRecentMessage = contextMessages.last {
            messageHistory =
            conversationHistoryDecorator + historicalContext + latestQueryDecorator + mostRecentMessage.content
            
            print("Final message history: \(messageHistory)")
            
        } else {
            messageHistory = "Historical Context:\n\(historicalContext)"
        }
        
    } // END createMessageHistory
    

    
    func fetchGPTResponse(for conversation: Conversation) async throws -> Message {
        print("|--- fetchGPTResponse --->")
        do {
            let response: GPTReponse = try await fetchGPTResponse(prompt: messageHistory)
            print("Received GPT response")
            
            guard let firstMessage = response.choices.first else {
                throw GPTError.couldNotGetLastResponse
            }
            print("Retrieved last message")
            
            let responseMessage = Message(content: firstMessage.message.content, type: .assistant, conversation: conversation)
            
            return responseMessage
            
        } catch {
            throw GPTError.failedToFetchResponse
        }
    }
    
    func createMessage(_ response: String, with type: MessageType, for conversation: Conversation) -> Message {
        print("|--- createMessage --->")
        
        let timeStamp = Date.now
        
        let formattedResponse: String = "Message type: \(type). Timestamp: \(timeStamp). Conversation ID: \(conversation.id). Message content: \(response)"
        print("Message created: " + formattedResponse)
        
        let newMessage = Message(
            timestamp: timeStamp,
            content: formattedResponse,
            type: type,
            conversation: conversation
        )
        
        return newMessage
    }
    
    
    //    static let activeConversationPredicate: Predicate<Conversation> = #Predicate<Conversation> {
    //        if let conversationID = bk.selectedConversations.first {
    //
    //        }
    //    }
}

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

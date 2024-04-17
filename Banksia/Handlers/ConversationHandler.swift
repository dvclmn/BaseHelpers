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
    
    var isTesting: Bool = true
    
    var isResponseLoading: Bool = false
    
    var isRequestingNewConversation: Bool = false

    /// This history should only be sent to GPT, not be saved to a Conversation. The Conversation has it's own array of Messages
    var messageHistory: String = ""
    
    
    func createMessageHistory(for conversation: Conversation, latestMessage: Message) async {
        
        guard let messages = conversation.messages, !messages.isEmpty else {
            messageHistory = ""
            print("No message in conversation")
            return
        }
        
        let sortedMessages = messages.sorted { $0.timestamp > $1.timestamp }

        let maxMessageContextCount: Int = 8
        
        let queryID: String = latestMessage.persistentModelID.hashValue.description
        
        let queryHeading: String = "\n\n# ||---- BEGIN Query #\(queryID) ---->> \n"
        let latestQueryDecorator: String = "## Latest Query\n"
        let conversationHistoryDecorator: String = "## Conversation History\n"
        let queryFooter: String = "\n# >>---- END Query #\(queryID) ----||\n\n"
        
        
        let historicalMessages: [Message] = sortedMessages.suffix(maxMessageContextCount).dropLast() /// Drop last, to exclude the message I *just* sent
        
        let historyFormatted: String = historicalMessages.map { formatMessageForGPT($0) }.joined(separator: "\n")
        
        let latestMessageFormatted: String = formatMessageForGPT(latestMessage)
        
        messageHistory = """
        \(queryHeading)
        \(latestQueryDecorator)
        \(latestMessageFormatted)
        \(conversationHistoryDecorator)
        \(historyFormatted)
        \(queryFooter)
        """

        print(messageHistory)
        
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
            
            print(">--- END fetchGPTResponse ---|\n")
            return responseMessage
            
        } catch {
            throw GPTError.failedToFetchResponse
        }
    }
    
    func createMessage(_ response: String, with type: MessageType, for conversation: Conversation) -> Message {
        print("|--- createMessage --->")
        
        let newMessage = Message(
            content: response,
            type: type,
            conversation: conversation
        )
        print(">--- END createMessage ---|\n")
        return newMessage
    }
    
    
    func formatMessageForGPT(_ message: Message) -> String {
        print("|--- formatMessageForGPT --->")
        
        let timeStamp: String = "Timestamp: \(Date.now)"
        let type: String = "Author: \(message.type.name)"
        let conversationID: String = "Conversation ID: \(message.conversation?.persistentModelID.hashValue.description ?? "No Conversation ID")"
        let content: String = "Message:\n\(message.content)"
        
        let formattedMessage: String = """
        \(timeStamp)
        \(type)
        \(conversationID)
        \(content)
        """
        print(">--- END formatMessageForGPT ---|\n")
        return formattedMessage
    }
    
}

enum ConversationState {
    case blank
    case none
    case single
    case multiple
    
    init(totalConversations: Int, selectedConversation: Set<Conversation.ID>) {
        if totalConversations == 0 {
            self = .blank
        } else {
            switch selectedConversation.count {
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


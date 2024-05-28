//
//  ConversationHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 15/11/2023.
//

import Foundation
import SwiftUI
import SwiftData
import Grainient

@Observable
final class ConversationHandler {
    
    let bk = BanksiaHandler()
    let pref = Preferences()
    
    var searchText: String = ""
    var isSearching: Bool = false

    var grainientSeed: Int? = nil
    
    var isResponseLoading: Bool = false
    
    var isRequestingNewConversation: Bool = false
    var isConversationEditorShowing: Bool = false
    var isRequestingSearch: Bool = false
    
    var selectedParagraph: String = ""
    
    /// This history should only be sent to GPT, not be saved to a Conversation. The Conversation has it's own array of Messages
    var messageHistory: String = ""
    
    var editorHeight: Double = ConversationHandler.defaultEditorHeight
    
    static let defaultEditorHeight: Double = 200
    
    func getConversation(from id: Conversation.ID, within conversations: [Conversation]) -> Conversation? {
        return conversations.first(where: {$0.id == id})
    }


    func createMessageHistory(for conversation: Conversation, latestMessage: Message) async {
        
        guard let messages = conversation.messages, !messages.isEmpty else {
            messageHistory = ""
            print("No message in conversation")
            return
        }
        
        /// Each query sent to GPT will be formatted into 4 parts
        /// 1. # Conversation name
        /// 2. ## Conversation-wide prompt
        /// 3. ## User query
        ///     - Sent
        ///     - Message body
        ///4. ## Previous Messages
        ///     - Author ({timestamp}):
        ///     - Message body
        
        /// Constants
        let maxMessagesInHistory: Int = 8
        
        /// Part 1
        let conversationHeading: String = "# Conversation: \"\(conversation.name)\""
        
        /// Part 2
        var conversationPromptHeading: String = ""
        var conversationPromptBody: String = ""
        
        if let prompt = conversation.prompt {
            conversationPromptHeading = "## Conversation-wide prompt"
            conversationPromptBody = "\(prompt)"
        }

        /// Part 3
        let latestMessageHeading: String = "## User Query"
        let latestMessagebody: String = "\(formatMessageForGPT(latestMessage))"
        
        /// Part 4
        let historyHeading: String = "## Previous Messages (newest to oldest)"

        /// Prune the messages, leaving the most recent 8, *not* including the latest message
        let historicalMessages: [Message] = messages
                .filter { $0.persistentModelID != latestMessage.persistentModelID }
                .sorted { $0.timestamp > $1.timestamp }
                
        let prunedHistory = historicalMessages.prefix(maxMessagesInHistory)

        let historyBody: String = prunedHistory.map {
            formatMessageForGPT($0)
        }.joined(separator: "\n\n")
        
        messageHistory = """
        \(conversationHeading)
        
        \(conversationPromptHeading)
        \(conversationPromptBody)
        
        \(latestMessageHeading)
        \(latestMessagebody)
        
        \(historyHeading)
        \(historyBody)
        """
        
        print(messageHistory)
        print(">--- END Message history ---|\n")
        
    } // END createMessageHistory
    
    func getRandomParagraph() -> String {
        ExampleText.paragraphs.randomElement() ?? "No paragraphs available"
    }
    
    func formatMessageForGPT(_ message: Message) -> String {
        
        print("|--- formatMessageForGPT --->")
        
        let messageHeading: String = "\(message.type.name) (\(ConversationHandler.formatTimestamp(message.timestamp))):"
        let messageFooter: String = "End of message from \(message.type.name) (\(ConversationHandler.formatTimestamp(message.timestamp)))."
        
        let formattedMessage: String = """
        \(messageHeading)
        \(message.content)
        \(messageFooter)
        """
        print(">--- END formatMessageForGPT ---|\n")
        return formattedMessage
    }
    
    static func formatTimestamp(_ timestamp: Date) -> String {
        return timestamp.formatted(.dateTime.year().month().day().hour().minute().second())
    }
    
    /// Parse a line from the stream and extract the message
    static func parse(_ line: String) -> String? {
        let components = line.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: true)
        guard components.count == 2, components[0] == "data" else { return nil }
        
        let message = components[1].trimmingCharacters(in: .whitespacesAndNewlines)
        
        if message == "[DONE]" {
            return "\n"
        } else {
            let chunk = try? JSONDecoder().decode(GPTResponse.self, from: message.data(using: .utf8)!)
            return chunk?.choices.first?.message.content
        }
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



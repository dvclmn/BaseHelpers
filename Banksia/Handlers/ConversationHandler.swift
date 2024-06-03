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
import MarkdownEditor
import KeychainSwift


@Observable
final class ConversationHandler {
    
    let keychain = KeychainSwift()
    
    var currentConversationID: Conversation.ID? = nil
    
    var userPrompt: String = ""
    
    var searchText: String = ""
    var isSearching: Bool = false
    
    var isEditorFocused: Bool = false
    
//    @Published var grainientSeed: Int? = nil
    
    var isResponseLoading: Bool = false
    
    var currentRequest: AppAction = .none
    
    var isConversationEditorShowing: Bool = false
    
    var scrolledMessageID: Message.ID?
//    var scrolledMessagePreview: String?
    
    var editorHeight: Double = ConversationHandler.defaultEditorHeight
    
    static let defaultEditorHeight: Double = 180
    
    func getConversation(from id: Conversation.ID, within conversations: [Conversation]) -> Conversation? {
        return conversations.first(where: {$0.id == id})
    }
    
    func createMessageHistory(for conversation: Conversation, latestMessage: Message, with systemPrompt: String) async -> [RequestMessage] {
        
        print("\n\n|--- Message History --->\n")
        
        let maxMessagesInHistory: Int = 2
        print("Max messages in history: \(maxMessagesInHistory)")
        
        let conversationPrompt: String = conversation.prompt ?? ""
        
        let system = RequestMessage(role: "system", content: systemPrompt + conversationPrompt)
        
        let latest = [RequestMessage(role: "user", content: latestMessage.content)]
        
        if let messages = conversation.messages {
            
            let history = messages
            
            /// This excludes the latest message, as I will handle that seperately
                .filter { $0.persistentModelID != latestMessage.persistentModelID }
            
            /// This sorts the messages in ascending order by their timestamps. This means older messages will come before newer messages, as expected by OpenAI's docs
            /// https://community.openai.com/t/managing-messages-array-for-multi-user-chat-with-gpt-3-5-turbo/85976/6
                .sorted { $0.timestamp < $1.timestamp }
            
//            print("Here are the messages from converation named '\(conversation.name)', in order of timestamp:\n\n")
//            print(history.prettyPrinted)
            
            /// Multiplying by two, to allow 2 per message type, 2 for user, 2 for assistant
            let prunedHistory = history.suffix(maxMessagesInHistory * 2)
            
            print("This pruned history should display 2x messages from user, and 2x messages from assistant, in order from oldest first, to newest at the end:")
            print(Array(prunedHistory).prettyPrinted(keyPath: \.content))
            
            let historicalMessages: [RequestMessage] = prunedHistory.map { message in
                let role: String
                switch message.type {
                case .user:
                    role = "user"
                case .assistant:
                    role = "assistant"
                }
                return RequestMessage(role: role, content: message.content)
            }
            
            // Prepend the system message
            return [system] + historicalMessages + latest
            
        } else {
            
            return [system] + latest
        }
    } // END create message history
    
    func getTidyMessageID(_ id: PersistentIdentifier.ID) -> String {
//        let idString: String = "\(id)"
//        let suffix = String(idString.suffix(67))
//        let final = String(suffix.prefix(3))
        
        let idString: String = "\(id)"
        let suffix = String(idString.suffix(200))
        let final = String(suffix.prefix(200))
        
        return final
    }
    
    func getMessageTimestamp(_ date: Date) -> String {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "hh:mm:ss a"
        /// "SSS" provides milliseconds, which we don't need right now
//        dateFormatter.dateFormat = "hh:mm:ss.SSS a"

        let formattedDate = dateFormatter.string(from: date)

        return formattedDate
    }
    
    
    
    static func formatTimestamp(_ timestamp: Date) -> String {
        return timestamp.formatted(.dateTime.year().month().day().hour().minute().second())
    }
    
    /// Parse a line from the stream and extract the message
    func totalTokens(for conversation: Conversation) -> Int {
        if let messages = conversation.messages {
            
            var promptTokens: Int = 0
            var completionTokens: Int = 0
            
            for message in messages {
                promptTokens += message.promptTokens.boundInt
                completionTokens += message.completionTokens.boundInt
            }
            
            return promptTokens + completionTokens
        } else {
            return 0
        }
    } // END total tokens
    
    @MainActor
    func hasAPIKeySetUp() -> Bool {
        if let apiKey = keychain.get("openAIAPIKey") {
            return true
        } else {
            return false
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

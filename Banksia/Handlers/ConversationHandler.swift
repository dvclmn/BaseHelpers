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



final class ConversationHandler: ObservableObject {
    
    @Published var currentConversationID: Conversation.ID? = nil
    
    @AppStorage("userPromptKey") var userPrompt: String = ""
    
    @Published var searchText: String = ""
    @Published var isSearching: Bool = false
    
    @Published var isEditorFocused: Bool = false
    
    @Published var grainientSeed: Int? = nil
    
    @Published var isResponseLoading: Bool = false
    
    @Published var currentRequest: AppAction = .none
    
    @Published var isConversationEditorShowing: Bool = false
    
    @Published var scrolledMessageID: Message.ID?
    @Published var scrolledMessagePreview: String?
    
//    var streamingGPTMessageID: Conversation.ID? = nil
//    var streamedResponse: String = ""
    
    var editorHeight: Double = ConversationHandler.defaultEditorHeight
    
    static let defaultEditorHeight: Double = 180
    
    func getConversation(from id: Conversation.ID, within conversations: [Conversation]) -> Conversation? {
        return conversations.first(where: {$0.id == id})
    }
    
    func createMessageHistory(for conversation: Conversation, latestMessage: Message, with systemPrompt: String) async -> [RequestMessage] {
        
        let maxMessagesInHistory: Int = 6
        
        let conversationPrompt: String = conversation.prompt ?? ""
        
        let system = RequestMessage(role: "system", content: systemPrompt + conversationPrompt)
        
        //        guard let messages = conversation.messages else {
        //            print("There were no messages to send")
        //            throw GPTError.failedToFetchResponse
        //        }
        
        // Filter out the latest message and sort by timestamp in descending order
        
        if let messages = conversation.messages {
            
            let history = messages
                .filter { $0.persistentModelID != latestMessage.persistentModelID }
                .sorted { $0.timestamp < $1.timestamp }
            
            let prunedHistory = history.prefix(maxMessagesInHistory)
            
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
            return [system] + historicalMessages
        } else {
            
            let latest = [RequestMessage(role: "user", content: latestMessage.content)]
            
            return [system] + latest
        }
    } // END create message history
    
    
    
    func getRandomParagraph() -> String {
        ExampleText.paragraphs.randomElement() ?? "No paragraphs available"
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
            let chunk = try? JSONDecoder().decode(GPTStreamedResponse.self, from: message.data(using: .utf8)!)
            return chunk?.choices.first?.delta.content
        }
    } // Stream parsing
    
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



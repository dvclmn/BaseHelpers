//
//  ConversationHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 15/11/2023.
//

import SwiftUI
import SwiftData

enum ConversationState {
    case blank
    case none
    case single
    case multiple

    init(totalConversations: Int, selectedConversations: Set<Conversation>) {
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
        // Create a new conversation object
        let newConversation = Conversation(name: "New conversation")
        
        modelContext.insert(newConversation)
        // Save the new conversation to the persistent store
        do {
            try modelContext.save()
            // Set the newly created conversation as the current conversation
        } catch {
            print("Failed to save new conversation: \(error)")
        }
        currentConversations = []
        currentConversations = [newConversation]
    }
    
    func deleteConversations(_ conversations: Set<Conversation>, modelContext: ModelContext) {
        currentConversations = []
        for conversation in conversations {
            modelContext.delete(conversation)
        }
    }
    
    func deleteAll(for modelContext: ModelContext) {
        currentConversations = []
        do {
            try modelContext.delete(model: Conversation.self)
        } catch {
            print("Failed to clear Conversations.")
        }
    } // END delete all
    

    
    func sendMessage(userMessage: String) {
        // Trim the message to remove leading and trailing whitespaces and newlines
        let trimmedMessage = userMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check if the trimmed message is empty and return early if it is
        guard !trimmedMessage.isEmpty else {
            print("Message is empty, nothing to send")
            return
        }
        
        // Ensure there is a single current conversation selected, return early if not
        guard currentConversations.count == 1 else {
            print("Multiple conversations selected or no conversation selected.")
            return
        }
        
        // Since we know there's exactly one conversation, we can safely access the first element
        let currentConversation = currentConversations.first!
        
        // Create a Message object for the user's message and append it to the conversation
        let userMessageObject = Message(content: "Q: \(trimmedMessage)", isUser: true, conversation: currentConversation)
        currentConversation.messages.append(userMessageObject)
        
        // Fetch the response from the server or API
        fetchResponse(prompt: trimmedMessage) { result in
            // Handle the response on the main thread to update the UI
            DispatchQueue.main.async {
                switch result {
                case .success(let textResponse):
                    // Create a Message object for the response and append it to the conversation
                    let responseMessage = Message(content: "A: \(textResponse)", isUser: false, conversation: currentConversation)
                    currentConversation.messages.append(responseMessage)
                case .failure(let error):
                    // Handle the error case by appending an error message to the conversation
                    let errorMessage = Message(content: "Error: \(error.localizedDescription)", isUser: false, conversation: currentConversation)
                    currentConversation.messages.append(errorMessage)
                }
                // Update the UI or save changes to the data model here if necessary
            } // END Dispatch queue
        } // END fetch response
    } // END send message
    

} // END BanksiaHandler extension

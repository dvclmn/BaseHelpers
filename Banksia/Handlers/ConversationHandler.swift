//
//  ConversationHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 15/11/2023.
//

import SwiftUI
import SwiftData

enum AIModel: String, Codable, CaseIterable {
    case gpt_4
    case gpt_3_5
    
    var name: String {
        switch self {
        case .gpt_4:
            return "GPT-4"
        case .gpt_3_5:
            return "GPT-3.5 Turbo"
        }
    }
    var value: String {
        switch self {
        case .gpt_4:
            return "gpt-4"
        case .gpt_3_5:
            return "gpt-3.5-turbo"
        }
    }
} // END AIModel

extension BanksiaHandler {
    
    func newConversation(for modelContext: ModelContext) {
        // Create a new conversation object
        let newConversation = Conversation(name: "New conversation")
        
        modelContext.insert(newConversation)
        // Save the new conversation to the persistent store
        do {
            try modelContext.save()
            // Set the newly created conversation as the current conversation
            currentConversations = [newConversation]
        } catch {
            print("Failed to save new conversation: \(error)")
        }
    }
    
    func deleteConversation(_ conversation: Conversation, modelContext: ModelContext) {
        currentConversations = []
        modelContext.delete(conversation)
    }
    
    func deleteAll(for modelContext: ModelContext) {
        do {
            try modelContext.delete(model: Conversation.self)
        } catch {
            print("Failed to clear Conversations.")
        }
    } // END delete all
    
    func testAPIFetch() {
        fetchResponse(prompt: "Your prompt here", completion:  { result in
            switch result {
            case .success(let data):
                // Handle the raw data, or save it to a file for inspection
                
                print("Raw data received:\n\(data)")
            case .failure(let error):
                // Handle the error
                print("Error fetching API response: \(error)")
            }
        }, isTest: true)
    }
    
    func sendMessage(userMessage: String) {
        // Trim the message to remove leading and trailing whitespaces and newlines
        let trimmedMessage = userMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check if the trimmed message is empty and return early if it is
        guard !trimmedMessage.isEmpty else {
            print("Message is empty, nothing to send")
            return
        }
        
        // Ensure there is a single current conversation selected, return early if not
        guard let currentConversations = currentConversations, currentConversations.count == 1 else {
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

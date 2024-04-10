//
//  BanksiaHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 14/11/2023.
//

import SwiftUI

@Observable
class BanksiaHandler {
    var currentConversations: Set<Conversation> = []
    var totalConversations: Int = 0
    
    var currentModel: AIModel = .gpt_4_turbo
    var currentTemperature: Double = 0.5
    var currentTextScale: Double = 1
    
    var conversationState: ConversationState {
        ConversationState(totalConversations: totalConversations, selectedConversations: currentConversations)
    }
    
    var sidebarVisibility: NavigationSplitViewVisibility = .automatic
    
    var isOptionKey: Bool = false

    /// Corner radius
    let cornerRadiusSmall: CGFloat = 6
    let cornerRadiusLarge: CGFloat = 10
    
    
    init() {
//        saveAPIKeyToKeychainForDebugging()
        
    }
    
    func saveAPIKeyToKeychainForDebugging() {
        let apiKey = "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"
        let savedSuccessfully = KeychainHandler.set(apiKey, forKey: "OpenAIKey")
        
        if savedSuccessfully {
//            print("Debugging API key saved successfully to Keychain.")
        } else {
            print("Failed to save debugging API key to Keychain.")
        }
    }
}


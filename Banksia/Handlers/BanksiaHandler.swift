//
//  BanksiaHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 14/11/2023.
//

import SwiftUI
import SwiftData

@Observable
class BanksiaHandler {
    
    let pref = Preferences()
    
    var selectedConversations: Set<Conversation.ID> = []
    
    var totalConversations: Int = 0

    var conversationState: ConversationState {
        ConversationState(totalConversations: totalConversations, selectedConversations: selectedConversations)
    }
    
    var sidebarVisibility: NavigationSplitViewVisibility = .detailOnly
    
    var isOptionKey: Bool = false
    
    var isResponseLoading: Bool = false

    
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


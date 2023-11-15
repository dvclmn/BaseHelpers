//
//  BanksiaHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 14/11/2023.
//

import SwiftUI

@Observable
class BanksiaHandler {
    var currentConversation: Conversation? = nil
    var columnVisibility: NavigationSplitViewVisibility = .automatic
    
    var sidebarTitle = "Conversation"
    
    
    init() {
        saveAPIKeyToKeychainForDebugging()
    }
    
    func saveAPIKeyToKeychainForDebugging() {
            let apiKey = "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"
            let savedSuccessfully = KeychainHandler.set(apiKey, forKey: "OpenAIKey")
            
            if savedSuccessfully {
                print("Debugging API key saved successfully to Keychain.")
            } else {
                print("Failed to save debugging API key to Keychain.")
            }
        }
}


//
//  BanksiaHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 14/11/2023.
//

import SwiftUI

//@Observable
class BanksiaHandler: ObservableObject {
    @Published var currentConversations: Set<Conversation> = []
    @Published var sidebarVisibility: NavigationSplitViewVisibility = .automatic
    
    @Published var isOptionKey: Bool = false
    
    @AppStorage("globalTextSize") var globalTextSize: Double = 1.0
    @AppStorage("myTemperature") var temperature: Double = 0.5
    
    @AppStorage("myModel") var modelString: String = AIModel.gpt_4.value
    var myModel: AIModel {
        get { AIModel(rawValue: modelString) ?? .gpt_4 }
        set { modelString = newValue.value }
    }
    
    /// Corner radius
    let cornerRadiusSmall: CGFloat = 6
    let cornerRadiusLarge: CGFloat = 10
    
    
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


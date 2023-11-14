//
//  SampleData+Conversation.swift
//  Banksia
//
//  Created by Dave Coleman on 13/11/2023.
//

import Foundation

import Foundation
import SwiftData

extension Conversation {
    static let plants = Conversation(name: "Identifying plants")
    static let appKitDrawing = Conversation(name: "AppKit for drawing in SwiftUI")
    static let childcare = Conversation(name: "How to raise kids")

    static func insertSampleData(modelContext: ModelContext) {
        // Add the conversations to the model context.
        modelContext.insert(plants)
        modelContext.insert(appKitDrawing)
        modelContext.insert(childcare)
        
        // Add the user prompts to the model context.
        modelContext.insert(UserPrompt.prompt_01)
        modelContext.insert(UserPrompt.prompt_02)
        modelContext.insert(UserPrompt.prompt_03)
        
        // Add the GPT repsonses to the model context.
        modelContext.insert(GPTResponse.response_01)
        modelContext.insert(GPTResponse.response_02)
        modelContext.insert(GPTResponse.response_03)
    }
    
    static func reloadSampleData(modelContext: ModelContext) {
        do {
            try modelContext.delete(model: Conversation.self)
            insertSampleData(modelContext: modelContext)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

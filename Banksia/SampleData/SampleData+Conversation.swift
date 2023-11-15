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
        modelContext.insert(Message.prompt_01)
        modelContext.insert(Message.prompt_02)
        modelContext.insert(Message.prompt_03)
        
        // Add the GPT repsonses to the model context.
        modelContext.insert(Message.response_01)
        modelContext.insert(Message.response_02)
        modelContext.insert(Message.response_03)
        
        let messages: [Message] = [
            Message.prompt_01,
            Message.response_01,
            Message.prompt_02,
            Message.response_02,
            Message.prompt_03,
            Message.response_03
        ]
        plants.messages = messages
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

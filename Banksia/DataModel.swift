//
//  DataModel.swift
//  Banksia
//
//  Created by Dave Coleman on 13/11/2023.
//

import Foundation
import SwiftData

@Model
final class Conversation {
    var created: Date
    var name: String
    var icon: String?
    var tokens: Int?
    
    @Relationship(deleteRule: .cascade)
    var messages: [Message] = []
    
    init(
        created: Date = .now,
        name: String,
        icon: String = "",
        tokens: Int = 0
    ) {
        self.created = created
        self.name = name
        self.icon = icon
        self.tokens = tokens
    }
} // END Conversation

@Model
final class Message {
    var timestamp: Date
    var content: String
    var tokens: Int?
    var isUser: Bool
    var conversation: Conversation
    
    init(
        timestamp: Date = .now,
        content: String,
        tokens: Int? = 0,
        isUser: Bool = true,
        conversation: Conversation = Conversation(name: "Example fallback")
    ) {
        self.timestamp = timestamp
        self.content = content
        self.tokens = tokens
        self.isUser = isUser
        self.conversation = conversation
    }
} // END Message

@Model
final class UserPrefs {
    var textScale: Double
    var gptTemperature: Double
    var gptModel: AIModel
    
    init(
        textScale: Double = 1.0,
        gptTemperature: Double = 0.5,
        gptModel: AIModel = AIModel.gpt_4
    ) {
        self.textScale = textScale
        self.gptTemperature = gptTemperature
        self.gptModel = gptModel
    }
}

struct APIResponse: Codable {
    struct Choice: Codable {
        let message: Message
        let finishReason: String
        let index: Int
        
        enum CodingKeys: String, CodingKey {
            case message
            case finishReason = "finish_reason"
            case index
        }
    }
    struct Message: Codable {
        let role: String
        let content: String
    }
    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [Choice]
    let usage: APIUsage
}

struct APIUsage: Codable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int
    
    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}

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
    var name: String
    var icon: String?
    var created = Date()
    var tokens: Int?
    
    @Relationship(deleteRule: .cascade)
    var messages: [Message] = []
    
    init(name: String, icon: String = "") {
        self.name = name
        self.icon = icon
    }
} // END Conversation

@Model
final class Message {
    @Attribute(.unique) var timestamp = Date()
    var content: String
    var tokens: Int?
    var isUser: Bool
    var conversation: Conversation
    
    init(timestamp: Date = .now, content: String, tokens: Int? = nil, isUser: Bool = true, conversation: Conversation) {
        self.timestamp = timestamp
        self.content = content
        self.tokens  = tokens
        self.isUser = isUser
        self.conversation = conversation
    }
} // END Message

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

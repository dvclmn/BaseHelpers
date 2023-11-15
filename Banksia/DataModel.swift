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
    var created = Date()
    
    @Relationship(deleteRule: .cascade)
    var messages: [Message] = []
    
    init(name: String) {
        self.name = name
    }
} // END Conversation

@Model
final class Message {
    @Attribute(.unique) var timestamp: Date
    var content: String
    var isUser: Bool
    var conversation: Conversation
    
    init(timestamp: Date = .now, content: String, isUser: Bool = true, conversation: Conversation) {
        self.timestamp = timestamp
        self.content = content
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
    let usage: APIUsage
    let choices: [Choice]
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

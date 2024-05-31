//
//  DataModel.swift
//  Banksia
//
//  Created by Dave Coleman on 13/11/2023.
//

import Foundation
import SwiftData

@Model
final class Conversation: Identifiable, Codable {
    var created: Date = Date.now
    var name: String = "New conversation"
    var icon: String? = nil
    var prompt: String? = nil
    var assistantName: String = "Assistant"
    var grainientSeed: Int? = nil
    
    @Relationship(deleteRule: .cascade, inverse: \Message.conversation) var messages: [Message]? = []
    
    init(
        created: Date = Date.now,
        name: String = "New conversation",
        icon: String? = nil,
        prompt: String? = nil,
        assistantName: String = "Assistant",
        grainientSeed: Int? = nil,
        messages: [Message]? = []
        
    ) {
        self.created = created
        self.name = name
        self.icon = icon
        self.prompt = prompt
        self.assistantName = assistantName
        self.grainientSeed = grainientSeed
        self.messages = messages
    }
    
    required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            created = try container.decode(Date.self, forKey: .created)
            name = try container.decode(String.self, forKey: .name)
            icon = try container.decodeIfPresent(String.self, forKey: .icon)
            prompt = try container.decodeIfPresent(String.self, forKey: .prompt)
            assistantName = try container.decode(String.self, forKey: .assistantName)
            grainientSeed = try container.decodeIfPresent(Int.self, forKey: .grainientSeed)
            messages = try container.decodeIfPresent([Message].self, forKey: .messages)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(created, forKey: .created)
            try container.encode(name, forKey: .name)
            try container.encodeIfPresent(icon, forKey: .icon)
            try container.encodeIfPresent(prompt, forKey: .prompt)
            try container.encode(assistantName, forKey: .assistantName)
            try container.encodeIfPresent(grainientSeed, forKey: .grainientSeed)
            try container.encodeIfPresent(messages, forKey: .messages)
        }

        private enum CodingKeys: String, CodingKey {
            case created
            case name
            case icon
            case prompt
            case assistantName
            case grainientSeed
            case messages
        }
} // END Conversation


@Model
final class Message: Identifiable, Codable {
    var timestamp: Date = Date.now
    var content: String = ""
    
    var promptTokens: Int? = nil
    var completionTokens: Int? = nil
    
    var type: MessageType = MessageType.user
    var conversation: Conversation? = nil
    
    init(
        timestamp: Date = .now,
        content: String = "",
        
        promptTokens: Int? = nil,
        completionTokens: Int? = nil,
        
        type: MessageType = MessageType.user,
        conversation: Conversation? = nil
    ) {
        self.timestamp = timestamp
        self.content = content
        
        self.promptTokens = promptTokens
        self.completionTokens = completionTokens
        
        self.type = type
        self.conversation = conversation
    }
    
    required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            timestamp = try container.decode(Date.self, forKey: .timestamp)
            content = try container.decode(String.self, forKey: .content)
            promptTokens = try container.decodeIfPresent(Int.self, forKey: .promptTokens)
            completionTokens = try container.decodeIfPresent(Int.self, forKey: .completionTokens)
            type = try container.decode(MessageType.self, forKey: .type)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(timestamp, forKey: .timestamp)
            try container.encode(content, forKey: .content)
            try container.encodeIfPresent(promptTokens, forKey: .promptTokens)
            try container.encodeIfPresent(completionTokens, forKey: .completionTokens)
            try container.encode(type, forKey: .type)
        }

        private enum CodingKeys: String, CodingKey {
            case timestamp
            case content
            case promptTokens
            case completionTokens
            case type
        }

} // END Message

enum MessageType: Codable {
    case user
    case assistant
    
    var name: String {
        switch self {
        case .user:
            return "User"
        case .assistant:
            return "Assistant"
        }
    }
}

struct ExportData: Codable {
    var systemPrompt: String
    var created: TimeInterval
    var conversations: [Conversation]
}

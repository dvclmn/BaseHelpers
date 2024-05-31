//
//  DataModel.swift
//  Banksia
//
//  Created by Dave Coleman on 13/11/2023.
//

import Foundation
import SwiftData

@Model
final class Conversation: Identifiable {
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
} // END Conversation

@Model
final class Message: Identifiable {
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

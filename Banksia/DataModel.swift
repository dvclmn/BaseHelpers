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
    var name: String = ""
    var icon: String? = nil
    var tokens: Int? = nil
    
    @Relationship(deleteRule: .cascade, inverse: \Message.conversation) var messages: [Message]? = []
    
    var history: String = ""
    
    init(
        created: Date = Date.now,
        name: String = "",
        icon: String? = nil,
        tokens: Int? = nil,
        messages: [Message]? = [],
        history: String = ""
        
    ) {
        self.created = created
        self.name = name
        self.icon = icon
        self.tokens = tokens
        self.messages = messages
        self.history = history
    }
} // END Conversation

@Model
final class Message {
    var timestamp: Date = Date.now
    var content: String = ""
    var tokens: Int? = nil
    var type: MessageType? = nil
    var conversation: Conversation? = nil
    
    init(
        timestamp: Date = .now,
        content: String = "",
        tokens: Int? = nil,
        type: MessageType? = nil,
        conversation: Conversation? = nil
    ) {
        self.timestamp = timestamp
        self.content = content
        self.tokens = tokens
        self.type = type
        self.conversation = conversation
    }
} // END Message

enum MessageType: String, Codable {
    case user
    case assistant
    
    var name: String {
        switch self {
        case .user:
            "User"
        case .assistant:
            "Assistant"
        }
    }
}

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

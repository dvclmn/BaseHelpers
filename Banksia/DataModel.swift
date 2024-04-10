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
    
    @Relationship(deleteRule: .cascade, inverse: \Message.conversation) var messages: [Message]? = []
    
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
    var conversation: Conversation?
    
    init(
        timestamp: Date = .now,
        content: String,
        tokens: Int? = 0,
        isUser: Bool = true,
        conversation: Conversation? = nil
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

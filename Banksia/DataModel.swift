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
    
    @Relationship(deleteRule: .cascade, inverse: \UserPrompt.conversation)
    var prompts: [UserPrompt]?
    
    init(name: String) {
        self.name = name
    }
} // END Conversation

@Model
final class UserPrompt {
    var timestamp = Date()
    var content: String
    var conversation: Conversation
    var response: GPTResponse?
    
    init(content: String, conversation: Conversation) {
        self.content = content
        self.conversation = conversation
    }
} // END UserPrompt

@Model
final class GPTResponse {
    var timestamp = Date()
    var content: String
    var prompt: UserPrompt
    
    init(content: String, prompt: UserPrompt) {
        self.content = content
        self.prompt = prompt
    }
} // END GPTResponse



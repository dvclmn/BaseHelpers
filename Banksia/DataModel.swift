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
    var prompts = [UserPrompt]()
    
    init(name: String) {
        self.name = name
    }
} // END Conversation

extension Conversation {
    static var preview: Conversation {
        Conversation(name: "Identifying plants")
    }
}

@Model
final class UserPrompt {
    var timestamp = Date()
    var conversation: Conversation
    var response: GPTResponse?
    
    init(conversation: Conversation) {
        self.conversation = conversation

    }
}

@Model
final class GPTResponse {
    var timestamp = Date()
    var prompt: UserPrompt
    
    init(prompt: UserPrompt) {
        self.prompt = prompt
    }
}



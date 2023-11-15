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
//    var prompts: [UserPrompt]?
    var messages: [Message] = []
    
    init(name: String) {
        self.name = name
    }
} // END Conversation

@Model
final class UserPrompt: Message {
    var timestamp = Date()
    var content: String
    @Relationship var conversation: Conversation
    var response: GPTResponse?
    
    init(content: String, conversation: Conversation) {
        self.content = content
        self.conversation = conversation
    }
    
    func getContent() -> String {
        return "UserPrompt: \(content)"
    }
} // END UserPrompt

@Model
final class GPTResponse: Message {
    var timestamp = Date()
    var content: String
    var prompt: UserPrompt
    
    init(content: String, prompt: UserPrompt) {
        self.content = content
        self.prompt = prompt
    }
    func getContent() -> String {
        return "GPTResponse: \(content)"
    }
} // END GPTResponse

protocol Message {
    var timestamp: Date { get }
    func getContent() -> String
}


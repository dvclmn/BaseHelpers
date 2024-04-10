//
//  GPTHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 20/11/2023.
//

import Foundation

struct OpenAI {
    
    static let chatURL: String = "https://api.openai.com/v1/chat/completions"
}

struct RequestBody: Codable {
    let model: String
    let messages: [RequestMessage]
    let temperature: Double
}

struct RequestMessage: Codable {
    let role: String
    let content: String
}


struct GPTReponse: Codable {
    
    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [GPTChoice]
    let usage: APIUsage
    let system_fingerprint: String
}

struct GPTChoice: Codable {
    let index: Int
    let message: GPTMessage
    let finish_reason: String
}
struct GPTMessage: Codable {
    let role: String
    let content: String
}


struct APIUsage: Codable {
    let prompt_tokens: Int
    let completion_tokens: Int
    let total_tokens: Int
    
}


enum AIModel: String, Codable, CaseIterable {
    case gpt_4_turbo
    case gpt_4
    case gpt_3_5
    
    var name: String {
        switch self {
        case .gpt_4_turbo:
            "GPT-4-Turbo"
        case .gpt_4:
            "GPT-4"
        case .gpt_3_5:
            "GPT-3.5 Turbo"
        }
    }
    var value: String {
        switch self {
        case .gpt_4_turbo:
            "gpt-4-turbo"
        case .gpt_4:
            "gpt-4"
        case .gpt_3_5:
            "gpt-3.5-turbo"
        }
    }
} // END AIModel

//
//  GPTHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 20/11/2023.
//

import Foundation
import APIHandler

struct OpenAIHandler {
    static let chatURL: String = "https://api.openai.com/v1/chat/completions"
}

/// This and `RequestMessage` are created by me, to *send* to OpenAI, not based on data being received
struct RequestBody: Codable {
    let model: String
    let messages: [RequestMessage]
    let stream: Bool
    let temperature: Double
}

struct RequestMessage: Codable {
    let role: String
    let content: String
}



struct TestResponse: Codable {
    let object: String
    let data: [TestResponseData]
}
struct TestResponseData: Codable {
    let id: String
    let object: String
    let created: Int
    let owned_by: String
}

struct GPTResponse: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let usage: APIUsage
    let choices: [GPTChoice]
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

struct GPTStreamedResponse: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
//    let usage: APIUsage
    let choices: [GPTStreamedChoice]
}

struct GPTStreamedChoice: Codable {
//    let index: Int
    let delta: GPTStreamedMessage
    let finish_reason: String?
}

struct GPTStreamedMessage: Codable {
    let role: String?
    let content: String?
}


struct APIUsage: Codable {
    let prompt_tokens: Int
    let completion_tokens: Int
    let total_tokens: Int
    
}
//
//struct OpenAI: AICompany {
//
//    let name: String = "OpenAI"
//    let models: [GPTModel.AllCases]
//}


enum GPTModel: String, AIModel, Codable, CaseIterable {
    
    case gpt_4o
    case gpt_4_turbo
    case gpt_4
    case gpt_3_5
    
    var name: String {
        switch self {
        case .gpt_4o:
            "GPT-4o"
        case .gpt_4_turbo:
            "GPT-4 Turbo"
        case .gpt_4:
            "GPT-4"
        case .gpt_3_5:
            "GPT-3.5 Turbo"
        }
    }
    
    var model: String {
        switch self {
        case .gpt_4o:
            "gpt-4o"
        case .gpt_4_turbo:
            "gpt-4-turbo"
        case .gpt_4:
            "gpt-4"
        case .gpt_3_5:
            "gpt-3.5-turbo"
        }
    }
    
    var company: String {
        return "OpenAI"
    }
    
    var contextLength: String {
        switch self {
        case .gpt_4o:
            "128,000"
        case .gpt_4_turbo:
            "128,000"
        case .gpt_4:
            "8,192"
        case .gpt_3_5:
            "16,385"
        }
    }
    
    var cutoff: String {
        switch self {
        case .gpt_4o:
            "Oct 2023"
        case .gpt_4_turbo:
            "Dec 2023"
        case .gpt_4:
            "Sep 2021"
        case .gpt_3_5:
            "Sep 2021"
        }
    }
    
    var infoURL: String {
        switch self {
        case .gpt_4o:
            "gpt-4o"
        case .gpt_4_turbo, .gpt_4:
            "gpt-4-turbo-and-gpt-4"
        case .gpt_3_5:
            "gpt-3-5-turbo"
        }
    }
    
    static let openAIModelInfoURL: String = "https://platform.openai.com/docs/models"
    
} // END AIModel

enum GPTError: Error  {
    case couldNotGetLastResponse
    case failedToFetchResponse
}

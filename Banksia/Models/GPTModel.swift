//
//  GPTHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 20/11/2023.
//

import Foundation
import APIHandler
import Table

struct OpenAIHandler {
    static let chatURL: String = "https://api.openai.com/v1/chat/completions"
}

/// This and `RequestMessage` are created by me, to *send* to OpenAI, not based on data being received
/// Visit https://platform.openai.com/docs/api-reference/chat/create#chat-create-stream_options
/// For a lot more parameters such as `frequency_penalty` etc to learn about, and consider including in Banksia
struct RequestBody: Codable {
    let model: String
    let messages: [RequestMessage]
    let stream: Bool
    let stream_options: GPTStreamOptions
    let max_tokens: Int?
    let temperature: Double
}

struct RequestMessage: Codable {
    let role: String
    let content: String
}

struct GPTStreamOptions: Codable {
    let include_usage: Bool
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

/// Non-streamed DTOs
//struct GPTResponse: Codable {
//    let id: String
//    let object: String
//    let created: Int
//    let model: String
//    let usage: APIUsage
//    let choices: [GPTChoice]
//}
//
//struct GPTChoice: Codable {
//    let index: Int
//    let message: GPTMessage
//    let finish_reason: String
//}
//
//struct GPTMessage: Codable {
//    let role: String
//    let content: String
//}

///Reference:  https://platform.openai.com/docs/api-reference/chat/object
struct GPTChunk: Codable {
    let id: String
    let object: String /// The object type, which is always chat.completion
    let created: Int
    let model: String
    let choices: [GPTStreamedChoice]
    let usage: GPTUsage? /// An optional field that will only be present when you set stream_options: {"include_usage": true} in your request
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

struct GPTUsage: Codable {
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


enum GPTModel: String, AIModel, Codable, CaseIterable, Rowable {
    
    case gpt_4o
    case gpt_4_turbo
    case gpt_4
    case gpt_3_5
    
    var id: String {
        self.name
    }
    
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
    
    var content: [String: Any] {
            return [
                GPTColumns.model.rawValue: self.name,
                GPTColumns.contextLength.rawValue: self.contextLength,
                GPTColumns.cutoff.rawValue: self.cutoff
            ]
        }
    
    static let openAIModelInfoURL: String = "https://platform.openai.com/docs/models"
    
} // END AIModel

enum GPTColumns: String, CaseIterable, Columnable {
    
    case model = "Model"
    case contextLength = "Context Length"
    case cutoff = "Knowledge Cutoff"
    
    public var id: String {
        self.rawValue
    }
    
    public var title: String? {
        self.rawValue
    }
    
    public var minWidth: Double {
        return 40
    }
}

extension GPTModel {
    func toCustomRow() -> CustomRow<GPTColumns> {
        var cells: [GPTColumns: String] = [:]
        for column in GPTColumns.allCases {
            if let value = self.content[column.rawValue] as? String {
                cells[column] = value
            }
        }
        return CustomRow(cells: cells)
    }
}

enum GPTError: Error  {
    case couldNotGetLastResponse
    case failedToFetchResponse
}

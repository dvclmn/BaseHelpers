//
//  GPTHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 20/11/2023.
//

import Foundation

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

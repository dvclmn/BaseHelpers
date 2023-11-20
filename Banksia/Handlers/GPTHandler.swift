//
//  GPTHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 20/11/2023.
//

import Foundation

enum AIModel: String, Codable, CaseIterable {
    case gpt_4
    case gpt_3_5
    
    var name: String {
        switch self {
        case .gpt_4:
            return "GPT-4"
        case .gpt_3_5:
            return "GPT-3.5 Turbo"
        }
    }
    var value: String {
        switch self {
        case .gpt_4:
            return "gpt-4"
        case .gpt_3_5:
            return "gpt-3.5-turbo"
        }
    }
} // END AIModel

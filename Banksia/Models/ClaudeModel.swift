//
//  ClaudeModel.swift
//  Eucalypt
//
//  Created by Dave Coleman on 27/5/2024.
//

import Foundation
import APIHandler

//--header "x-api-key: $ANTHROPIC_API_KEY" \
//     --header "anthropic-version: 2023-06-01" \
//     --header "content-type: application/json" \
//     --data \
//'{
//    "model": "claude-3-opus-20240229",
//    "max_tokens": 1024,
//    "messages": [
//        {"role": "user", "content": "Hello, world"}
//    ]
//}'

/// POST
struct ClaudeAPI: Encodable {
    static let apiKeyHeaderKey: String = "x-api-key"
    static let versionHeaderKey: String = "anthropic-version"
    static let versionHeaderValue: String = "2023-06-01"

}

/// GET
struct ClaudeResponse: Decodable {
    var id: String
    var type: String
    var role: String
    var model: String
    var content: [ClaudeContent]
    var stop_reason: String
//    var stop_sequence: String
    var usage: ClaudeUsage
}

struct ClaudeContent: Decodable {
    var type: String
    var text: String
}

struct ClaudeUsage: Decodable {
    var input_tokens: Int
    var output_tokens: Int
}

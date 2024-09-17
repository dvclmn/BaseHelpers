//
//  File.swift
//
//
//  Created by Dave Coleman on 20/7/2024.
//

import Foundation
import MemberwiseInit

public protocol AIRequestBody: Encodable, Sendable {
    var model: String { get }
    var messages: [RequestMessage] { get }
    var stream: Bool { get }
    var temperature: Double { get }
}


@MemberwiseInit(.public)
public struct OpenAIRequestBody: AIRequestBody {
    public let model: String
    public let messages: [RequestMessage]
    public let stream: Bool
    public let temperature: Double
    
    public let stream_options: StreamOptions?
    
    @MemberwiseInit(.public)
    public struct StreamOptions: Encodable, Sendable {
        public let include_usage: Bool
    }
}

@MemberwiseInit(.public)
public struct AnthropicRequestBody: AIRequestBody {
    public let model: String
    public let messages: [RequestMessage]
    public let stream: Bool
    public let temperature: Double
    
    public let system: String?
    public let max_tokens: Int?
}

@MemberwiseInit(.public)
public struct RequestMessage: Encodable, Sendable, Equatable {
    public let role: String
    public let content: String
}

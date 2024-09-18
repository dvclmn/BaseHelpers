//
//  File.swift
//  
//
//  Created by Dave Coleman on 20/7/2024.
//

import Foundation

public struct Anthropic: Codable, Sendable {
    public static let name: String = "Anthropic"
    public static let apiKey: String = "anthropicAPISecretKey"
    public static let endpoint: URL? = URL(string: "https://api.anthropic.com/v1/messages")
    public static let modelInfoURL: URL? = URL(string: "https://docs.anthropic.com/en/docs/about-claude/models")
    
    public static let requestType: APIRequestType = .post

    /// # Headers
    ///
    /// Authentication
    ///
    public static let authHeaderKey: String = "x-api-key"
    
    /// Version
    ///
    public static let versionHeaderKey: String = "anthropic-version"
    public static let versionHeaderValue: String = "2023-06-01"
    
    /// Content type
    ///
    public static let contentTypeHeaderKey: String = "content-type"
    public static let contentTypeHeaderValue: String = "application/json"

    /// Beta
    ///
    /// A value of `8192` requires header `anthropic-beta: max-tokens-3-5-sonnet-2024-07-15`, otherwise the max is `4096`.
    ///
    public static let betaHeaderKey: String = "anthropic-beta"
    public static let betaHeaderValue: String = "max-tokens-3-5-sonnet-2024-07-15"
    
    public static let maxTokens: Int = 8192
    
    public static func headers(with key: String) -> [String : String] {
        return [
            authHeaderKey : key,
            versionHeaderKey : versionHeaderValue,
            contentTypeHeaderKey : contentTypeHeaderValue,
            betaHeaderKey : betaHeaderValue
        ]
    }

}


public struct AnthropicContentBlockDelta: StreamedResponse {
    /// `delta` is what's expected from the JSON API call
    public let delta: Delta?
    
    public var responseData: StreamedResponseMessage? {
        return delta
    }
    
    public struct Delta: StreamedResponseMessage {
        public let type: String?
        public let text: String?
    }
}

public struct AnthropicMessageStart: StreamedResponse {
    public let type: String
    public let message: Message
    
    public var responseData: StreamedResponseMessage? {
        return message
    }
    
    public struct Message: StreamedResponseMessage {
        public let type: String?
        public let text: String?
        public let usage: Usage?
        
        public struct Usage: StreamedResponseUsage {
            /// These are the tokens used to make the user's query
            public let input_tokens: Int?
            /// These are the tokens used by the Assistant to make the initial part of the response — the rest will come from the `message_delta` event
            public let output_tokens: Int?
        }
    }
}

public struct AnthropicMessageDelta: StreamedResponse {
    public let type: String
    //    let delta: Delta
    public let usage: Usage?
    
    public struct Usage: StreamedResponseUsage {
        public var input_tokens: Int?
        public let output_tokens: Int?
    }
}


/// Non-streamed
public struct AnthropicResponse: APIResponse {
    public let type: String // Defaults to "message"
    public let role: String // Will be "assistant"
    public let content: [Message]
    public let stop_reason: String?
    public let model: String
    public let usage: Usage
    
    /// `content`
    public struct Message: Decodable, Sendable {
        public let type: String // defaults to "text"
        public let text: String
    }
    
    /// `usage`
    public struct Usage: APIUsage {
        public let input_tokens: Int
        public let output_tokens: Int
    }
    
}



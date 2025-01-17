//
//  File.swift
//
//
//  Created by Dave Coleman on 20/7/2024.
//

import Foundation

public struct Anthropic: Codable, Sendable {
  public static let name: String = "Anthropic"
  
  
#if DEBUG
  static let apiKey: String = "anthropicAPIKeyDebug"
#else
  static let apiKey: String = "anthropicAPIKey"
#endif
  
  
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
  
  public static func headers(with key: String) -> [String : String] {
    return [
      authHeaderKey : key,
      versionHeaderKey : versionHeaderValue,
      contentTypeHeaderKey : contentTypeHeaderValue,
      betaHeaderKey : betaHeaderValue
    ]
  }
  
}

/// Content block example:
///
/// ```
/// event: content_block_delta
/// data: {
///   "type":"content_block_delta",
///   "index":0,
///   "delta":{
///     "type":"text_delta",
///     "text":" I'm Claude"
///   }
/// }
/// ```

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
      
      /// ~~These are the tokens used by the Assistant to make the initial part of the response — the rest will come from the `message_delta` event~~
      /// If Claude is to be believed, I can disregard this `output_tokens` property,
      /// and instead need to make sure I get the value from the `message_delta` version.
      /// Apparently this output one is almost like a test. Dunno
      
      public let output_tokens: Int?
    }
  }
}

/// `message_delta` example
///
/// Note: The message delta will return the *total* output tokens.
///
/// ```
/// event: message_delta
/// data: {
///   "type": "message_delta",
///   "delta": {
///     "stop_reason": "end_turn",
///     "stop_sequence": null
///   },
///   "usage": {
///     "output_tokens":30
///   }
/// }
/// ```
public struct AnthropicMessageDelta: StreamedResponse {
  public let type: String
  public let usage: Usage?
  
  public struct Usage: StreamedResponseUsage {
    
    /// This is here to comply with `StreamedResponseUsage`.
    /// Don't expect any result from `input_tokens`, this value
    /// is obtained from ``AnthropicMessageStart``
    public var input_tokens: Int?
    
    /// This is the relevant property for `message_delta_`
    public let output_tokens: Int?
  }
}


/// Non-streamed
public struct AnthropicResponse: Decodable, Sendable {
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
  public struct Usage: Decodable, Sendable {
    public let input_tokens: Int
    public let output_tokens: Int
  }
  
}



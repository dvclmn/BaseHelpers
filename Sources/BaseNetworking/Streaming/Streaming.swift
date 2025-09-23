//
//  Streaming.swift
//  Collection
//
//  Created by Dave Coleman on 17/1/2025.
//

import Foundation

public protocol StreamedResponse: Decodable, Sendable {
  var responseData: StreamedResponseMessage? { get }
  var usage: StreamedResponseUsage? { get }
}

extension StreamedResponse {
  /// Sets to `nil` as default
  public var responseData: StreamedResponseMessage? { nil }
  public var usage: StreamedResponseUsage? { nil }
}

public protocol StreamedResponseMessage: Decodable, Sendable {
  var text: String? { get }
  var usage: StreamedResponseUsage? { get }
}
extension StreamedResponseMessage {
  public var text: String? { nil }
  public var usage: StreamedResponseUsage? { nil }
}

public protocol StreamedResponseUsage: Decodable, Sendable {
  var input_tokens: Int? { get }
  var output_tokens: Int? { get }
}
extension StreamedResponseMessage {
  public var input_tokens: Int? { nil }
}

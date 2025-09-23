//
//  Models+Common.swift
//  Networking
//
//  Created by Dave Coleman on 24/2/2025.
//

import Foundation

/// A type that can configure API requests with the required credentials.
///
/// Types adopting Authenticatable can use either a token or an API key.
/// They are responsible for fetching and/or refreshing credentials.
public protocol Authenticatable: Sendable {
  
  associatedtype Metadata: APIServiceMetadata

  /// The type of authentication.
  var authenticationMethod: AuthenticationMethod { get }
  
  var metadata: Metadata { get }
  
  /// The last authentication error, if any.
  var error: AuthError? { get set }
  
  /// Configures the given request with valid authentication credentials.
  ///
  /// - Parameters:
  ///   - request: A URL request that will be modified with the appropriate headers.
  ///   - code: For cases where a code is required to obtain a token.
  /// - Throws: An error if authentication fails.
//  @MainActor
  func authenticate(_ request: inout URLRequest, with code: String?) async throws
  
//  func headers(withCode code: String?) async throws -> [APIHeader]
}

//extension Authenticatable {
//  public var name: String {
//    serviceMetadata.name
//  }
//}

//extension Authenticatable {
  
//}

/// Authentication methods supported by the API.
public enum AuthenticationMethod: Sendable {
  case token
  case apiKey
  
  public var name: String {
    switch self {
      case .token:
        return "Token"
      case .apiKey:
        return "API Key"
    }
  }
}


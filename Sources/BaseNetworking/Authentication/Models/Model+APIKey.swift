//
//  Model+APIKey.swift
//  Networking
//
//  Created by Dave Coleman on 18/2/2025.
//

import Foundation

public protocol APIKeyAuthenticatable: Authenticatable {
  static var key: String { get }
  var authLocation: APIKeyLocation { get }
  func getKeyFromConfigFile() throws -> String
}

/// A protocol for types that require API Key based authentication.
//public protocol APIKeyAuth where Self: Authenticatable {
  
//  associatedtype Authenticator: Authenticatable
//  var auth: Authenticator { get }
//  var serviceMetadata: Metadata { get }
  /// The API key used for authentication. Key here refers to
  /// the key used to retrieve the secret, *not* the key itself.
//  static var key: String { get }

  /// The location where the API key should be set.
//  var authLocation: APIKeyLocation { get }

  /// This is only one method, need to ensure other methods are
  /// catered for...
  ///
  /// - Returns: The API key.
  /// - Throws: An error if the secure key cannot be obtained.
//  func getKeyFromConfigFile() throws -> String
//}

/// Describes the location of an API key in requests.
public enum APIKeyLocation: Sendable {
  /// The API key is encoded in the HTTP header.
  case header(APIHeader)

  /// The API key is added to the URL query parameters.
  /// > Important: This is the key for the key:value pair, not the secret key itself
  case queryParameter(key: String)

  public var name: String {
    switch self {
      case .header(let prefix):
        return "Header, with prefix: \(prefix)"
      case .queryParameter(let key):
        return "URL Query parameter, using key: \(key)"
    }
  }
}

extension APIKeyAuthenticatable {

  public var authenticationMethod: AuthenticationMethod { .apiKey }

  // MARK: - Authentication for API Key style
  public func authenticate(
    _ request: inout URLRequest,
    with code: String? = nil
  ) async throws {

    print("Performing a \(authenticationMethod.name) style authentication for \(Self.self), with auth location type: \(authLocation.name)")

    let secret: String

    if let code {
      print("Using a provided code for authentication")
      secret = code
    } else {
      print("Using the secret retrieved from `Config.xcconfig` for authentication")
      secret = try getKeyFromConfigFile()
    }

    switch authLocation {
      case .header(let headerType):
        print("Using auth location `header`, with type: \(headerType)")
//        let header: APIHeader = .authorization(key: , prefix: prefix)
        headerType.addToRequest(&request, secret: secret)

      case .queryParameter(let paramKey):
        print("Using auth location `queryParameter, with key: \(paramKey)`")
        guard let requestURL = request.url else {
          throw AuthError.invalidURL
        }
        /// Add to existing URL parameters
        guard var components = URLComponents(url: requestURL, resolvingAgainstBaseURL: true)
        else {
          throw AuthError.invalidURL
        }

        var queryItems = components.queryItems ?? []
        queryItems.append(URLQueryItem(name: paramKey, value: secret))
        components.queryItems = queryItems
        request.url = components.url
    }
  }

  public func getKeyFromConfigFile() throws -> String {
    let keyString = try Bundle.getStringFromInfoDict(Self.key)
    return keyString
  }
}

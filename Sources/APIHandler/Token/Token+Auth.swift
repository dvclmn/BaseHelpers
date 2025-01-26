//
//  API+Token.swift
//  Collection
//
//  Created by Dave Coleman on 17/1/2025.
//

import Foundation
import KeychainSwift

/// Dynamically generated Bearer Tokens
public protocol TokenAuth {

  associatedtype DTO: TokenDTO
  typealias Token = AuthToken<DTO>

  static var providerName: String { get }
  var keychain: KeychainSwift { get }

  /// These are only keys to unlock corresponding sensitive values.
  /// Not the values themselves.
  static var clientIDKey: String { get }
  static var clientSecretKey: String { get }

  /// For retrieval from the Keychain
  /// IMPORTANT: This must be unique between adopting types
  static var tokenKey: String { get }

  /// The base URL for token requests
  static var tokenBaseURL: String { get }

  /// The authentication flow type for this service
  /// ~~`static`, as should not change for a service, once set~~
  /// Back to instance property, so a `loginCode` (which is dynamic)
  /// can be obtained, for flows that require it
  var authFlow: TokenAuthFlow { get }

}

public protocol TokenDTO: Codable {
  var token: String { get }
  var expiresIn: Int { get }

  /// Not all Token-based APIs have refresh tokens
  var refreshToken: String? { get }
  var expirationDate: Date { get }
}

extension TokenDTO {
  public var refreshToken: String? { nil }
  public var expirationDate: Date {
    Date().addingTimeInterval(TimeInterval(expiresIn))
  }
}

extension TokenAuth {
  public static func getClientCredentials() -> Credentials? {
    do {
      let clientID = try APIHandler.getStringFromInfoDict(Self.clientIDKey)
      let clientSecret = try APIHandler.getStringFromInfoDict(Self.clientSecretKey)
      return Credentials(clientID: clientID, clientSecret: clientSecret)
    } catch {
      print("Failed to retrieve client credentials: \(error)")
      return nil
    }
  }

  public func createAuthURL() throws -> URL {
    var components = URLComponents(string: Self.tokenBaseURL)
    components?.queryItems = queryItems()

    guard let url = components?.url else {
      throw TokenError.invalidAuthURL
    }

    return url
  }

  func queryItems() -> [URLQueryItem] {
    switch authFlow {

      /// E.g. for IGDB
      case let .clientCredentials(credentials):
        return [
          URLQueryItem(name: "client_id", value: credentials.clientID),
          URLQueryItem(name: "client_secret", value: credentials.clientSecret),
          URLQueryItem(name: "grant_type", value: authFlow.grantType),
        ]

      /// E.g. for GOG
      case let .authorizationCode(credentials, code, redirectURI):
        return [
          URLQueryItem(name: "client_id", value: credentials.clientID),
          URLQueryItem(name: "client_secret", value: credentials.clientSecret),
          URLQueryItem(name: "grant_type", value: authFlow.grantType),
          URLQueryItem(name: "code", value: code),
          URLQueryItem(name: "redirect_uri", value: redirectURI),
        ]
    }
  }

  public func retrieveTokenFromKeychain() throws -> Token {
    print("Checking the keychain for a saved \(Self.providerName) token")
    guard let tokenData = keychain.getData(Self.tokenKey) else {
      throw TokenError.noTokenInKeychain
    }
    print("Found \(Self.providerName) token Data in Keychain, now attempting to decode.")
    let token = try Token.fromData(tokenData)
    print("Successfully decoded \(Self.providerName) token: \(token)")
    
    /// Add more detailed validation logging
    if token.isValid {
      print("Token is still valid. Expiration date: \(token.expiryDate)")
    } else {
      print("Token has expired. Expiration date: \(token.expiryDate), Current date: \(Date())")
      throw TokenError.tokenHasExpired
    }
    return token
  }

  private func fetchNewToken() async throws -> Token {
    print("Fetching new \(Self.providerName) token")

    let url = try createAuthURL()

    let response = try await APIHandler.requestAndFetch(
      url: url,
      dto: DTO.self,
      isDebugMode: true
    )

    let token = Token(from: response)

    try await saveToken(token)

    print("Successfully obtained and saved \(Self.providerName) token")
    return token

  }


  private func saveToken(_ token: Token) async throws {
    let tokenData = try token.asData()
    guard keychain.set(tokenData, forKey: Self.tokenKey) else {
      throw TokenError.keychainSaveFailed
    }
  }


  /// Retrieves and validates a token, with configurable behavior for missing or expired tokens
  /// - Parameter strategy: The strategy to use when handling token validation
  /// - Returns: A valid token
  /// - Throws: TokenError depending on the strategy and current token state
  public func getValidToken(strategy: TokenValidationStrategy) async throws -> Token {

    do {
      switch strategy {
        case .validateOnly:
          return try retrieveTokenFromKeychain()

        case .refreshIfExpired:
          if let token = try? retrieveTokenFromKeychain(), token.isValid {
            return token
          }
          return try await fetchNewToken()

        case .forceRefresh:
          return try await fetchNewToken()
      }
    } catch {
      print("Token error: \(error)")
      throw error
    }
  }

  var keychainDoesContainToken: Bool {
    keychain.getData(Self.tokenKey) != nil
  }

}

public enum TokenValidationStrategy {
  /// Only check if token exists and is valid
  case validateOnly
  /// Attempt to refresh an expired token
  case refreshIfExpired
  /// Force fetch a new token regardless of current state
  case forceRefresh
}



public enum TokenError: LocalizedError {
  case noTokenInKeychain
  case tokenHasExpired
  case refreshFailed(Error)
  case invalidTokenData
  case missingCredentials
  case authenticationFailed(Error)
  case keychainSaveFailed
  case invalidAuthURL

  public var errorDescription: String? {
    switch self {
      case .noTokenInKeychain:
        return "No token found in keychain"
      case .tokenHasExpired:
        return "Token has expired"
      case .refreshFailed(let error):
        return "Token refresh failed: \(error)"
      case .invalidTokenData:
        return "Invalid token data in keychain"
      case .missingCredentials:
        return "Client ID or Secret not found in Info.plist"
      case .authenticationFailed(let error):
        return "Authentication failed: \(error)"
      case .keychainSaveFailed:
        return "Failed to save token to keychain"
      case .invalidAuthURL:
        return "Invalid auth URL"
    }
  }
}


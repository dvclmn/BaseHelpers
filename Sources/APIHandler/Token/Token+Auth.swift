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
  
  var providerName: String { get }
  var keychainInstance: KeychainSwift { get }
  
  /// These are only keys to unlock corresponding sensitive values.
  /// Not the values themselves.
  static var clientIDKey: String { get }
  static var clientSecretKey: String { get }
  
  /// I think I could add `RequestType` once I understand everything better
  
  /// For retrieval from the Keychain
  /// IMPORTANT: This must be unique between adopting types
  static var tokenKey: String { get }
  
  /// The base URL for token requests
  static var tokenBaseURL: String { get }
  
  /// The authentication flow type for this service
  /// `static`, as should not change for a service, once set
  static var authFlow: AuthFlow { get }
  
//  static var tokenRequestDTO: TokenDTO.Type { get }
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
    guard let credentials = Self.getClientCredentials() else {
      throw TokenError.missingCredentials
    }
    
    var components = URLComponents(string: Self.tokenBaseURL)
    components?.queryItems = queryItems(for: credentials)
    
    guard let url = components?.url else {
      throw TokenError.invalidAuthURL
    }
    
    return url
  }
  
  func queryItems(for credentials: Credentials) -> [URLQueryItem] {
    switch Self.authFlow {
        
        /// E.g. for IGDB
      case .clientCredentials(_, _):
        return [
          URLQueryItem(name: "client_id", value: credentials.clientID),
          URLQueryItem(name: "client_secret", value: credentials.clientSecret),
          URLQueryItem(name: "grant_type", value: "client_credentials")
        ]
        
        /// E.g. for GOG
      case let .authorizationCode(_, _, code, redirectURI):
        return [
          URLQueryItem(name: "client_id", value: credentials.clientID),
          URLQueryItem(name: "client_secret", value: credentials.clientSecret),
          URLQueryItem(name: "grant_type", value: "authorization_code"),
          URLQueryItem(name: "code", value: code),
          URLQueryItem(name: "redirect_uri", value: redirectURI)
        ]
    }
  }
  
  public func retrieveTokenFromKeychain() throws -> Token {
    guard let tokenData = keychainInstance.getData(Self.tokenKey) else {
      throw TokenError.noTokenInKeychain
    }
    
    let token = try Token.fromData(tokenData)
    guard token.isValid else {
      throw TokenError.tokenHasExpired
    }
    
    return token
  }
  
  private func fetchNewToken() async throws -> Token {
    print("Fetching new \(providerName) token")
    
    let url = try createAuthURL()
    let request = try APIHandler.createRequest(
      url: url
      //      type: requestType
    )
    
    print("Requesting token from: \(request.url?.absoluteString ?? "unknown")")
    
    let dto: DTO = try await APIHandler.fetch(request: request)
    let token = Token(from: dto)
    
    try await saveToken(token)
    
    print("Successfully obtained and saved \(providerName) token")
    return token
    //    do {
    //
    //    } catch TokenError.missingCredentials {
    //      print("Missing credentials for \(tokenService.name)")
    //      throw TokenError.missingCredentials
    //
    //    } catch let error as TokenError {
    //      print("Token error: \(error)")
    //      throw error
    //
    //    } catch {
    //      print("Authentication failed: \(error)")
    //      throw TokenError.authenticationFailed(error)
    //    }
  }
  
  
  
  private func saveToken(_ token: Token) async throws {
    let tokenData = try token.asData()
    guard keychainInstance.set(tokenData, forKey: Self.tokenKey) else {
      throw TokenError.keychainSaveFailed
    }
  }
  
  
  /// Retrieves and validates a token, with configurable behavior for missing or expired tokens
  /// - Parameter strategy: The strategy to use when handling token validation
  /// - Returns: A valid token
  /// - Throws: TokenError depending on the strategy and current token state
  func getValidToken(strategy: TokenValidationStrategy) async throws -> Token {
    
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
    keychainInstance.getData(Self.tokenKey) != nil
  }
  
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
enum TokenValidationStrategy {
  /// Only check if token exists and is valid
  case validateOnly
  /// Attempt to refresh an expired token
  case refreshIfExpired
  /// Force fetch a new token regardless of current state
  case forceRefresh
}

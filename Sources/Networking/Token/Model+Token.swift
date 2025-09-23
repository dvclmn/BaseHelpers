//
//  Token+Models.swift
//  Networking
//
//  Created by Dave Coleman on 16/2/2025.
//

import Foundation
import KeychainSwift
//import MemberwiseInit

/// A protocol for handling token-based web API authentication.
//public protocol TokenAuthenticatable where Self: Authenticatable {
//  associatedtype ResponseDTO: APIResponse
//  typealias Token = AuthToken
//
//  /// The key used to store/retrieve the token in the keychain.
//  /// This must be unique among types conforming to `TokenAuth`.
//  static var tokenKey: String { get }
//
//  /// The base URL used when fetching or refreshing tokens.
//  static var tokenBaseURL: String { get }
//
//  /// An instance of the keychain for secure token storage.
//  var keychain: KeychainSwift { get }
//
//  /// Credentials (e.g. clientID, client secret) that may be needed for token requests.
//  var credentials: Credentials { get }
//
//  /// The location strategy for the token (for example, whether
//  /// or not a client id is required in the headers).
//  var authLocation: TokenLocation { get }
//
//  /// The HTTP method to use for token requests.
//  var requestMethod: RequestMethod { get }
//
//  /// Returns the URL used to obtain (or refresh) a token.
//  ///
//  /// - Parameter code: Optionally, a login or verification code.
//  /// - Returns: A valid request URL.
//  /// - Throws: An error if the URL cannot be constructed.
//  func authURL(code: String?) throws -> RequestURL
//
//}
//
//extension TokenAuthenticatable {
//
//  /// A convenience accessor for the client ID.
//  public var clientID: String? {
//    getCredentials()?.clientID
//  }
//
//  /// A convenience accessor for the client secret.
//  public var clientSecret: String? {
//    getCredentials()?.clientSecret
//  }
//
//  /// Retrieves credentials from the associated credentials storage.
//  private func getCredentials() -> Credentials.Values? {
//    credentials.getCredentials()
//  }
//
//  /// Creates the needed request headers for an authenticated API call.
//  ///
//  /// - Parameter code: A code if required for token refresh flows.
//  /// - Returns: An array of headers to be used with the API request.
//  /// - Throws: An error if the headers cannot be generated (eg: missing credentials).
//  //  public func headers(withCode code: String?) async throws -> [APIHeader] {
//  //
//  //
//  //  }
//}
//
///// The supported locations/strategies for passing a token.
//public enum TokenLocation: Sendable {
//  /// The token is sent in the Authorization header.
//  case headerToken
//
//  /// The token is sent in the Authorization header and a clientID is also required.
//  case headerTokenAndClientID
//
//  public var displayName: String {
//    switch self {
//      case .headerToken:
//        return "Authorization header only"
//      case .headerTokenAndClientID:
//        return "Authorization header with Client-ID"
//    }
//  }
//}

/// Describes the expected token data transfer object.
///
/// These properties express the data we usually want,
/// and conforming types should point to the *actual*
/// properties the API exposes.
///
/// NOTE: Have since determined that this doesn't warrant
/// a whole protocol. Just define the DTO, and have
/// ``AuthToken`` handle it
//public protocol TokenResponseDTO: APIResponse {
//
//  /// The authentication token.
//  var token: String { get }
//
//  /// Refresh token (if provided)
//  var refreshToken: String? { get }
//
//  /// The duration (in seconds) that the token is valid.
//  var expiresIn: Int { get }
//
//  /// Capture current date/time, useful for computing expiry
//  var dateReceived: Date { get }
//  
//  /// Computes an expiry date based on date received
//  /// and provided expiry time
//  var expirationDate: Date { get }
//}
//
//extension TokenResponseDTO {
//  public var refreshToken: String? { nil }
//
//  public var expirationDate: Date {
//    Date().addingTimeInterval(TimeInterval(expiresIn))
//  }
//}



/// The strategy used when validating or refreshing a token.
//public enum TokenValidationStrategy {
//  /// Only verify that a token exists and has not expired.
//  case validateOnly
//
//  /// If the token is expired, attempt to refresh it.
//  case refreshIfExpired
//
//  /// Force the retrieval of a new token regardless of the current token’s state.
//  case forceRefresh
//}

// MARK: - Error
//public enum TokenError: LocalizedError {
//  case noTokenInKeychain
//  case couldNotGetNewToken
//  case rateLimitExceeded
//  case networkUnavailable
//  case tokenHasExpired
//  case refreshFailed(Error)
//  case invalidTokenData
//  case missingCredentials
//  case authenticationFailed(Error)
//  case keychainSaveFailed
//  case invalidAuthURL
//
//  public var errorDescription: String? {
//    switch self {
//      case .noTokenInKeychain: "No token found in keychain"
//      case .tokenHasExpired: "Token has expired"
//      case .refreshFailed(let error): "Token refresh failed: \(error)"
//      case .invalidTokenData: "Invalid token data in keychain"
//      case .missingCredentials: "Client ID or Secret not found in Info.plist"
//      case .authenticationFailed(let error): "Authentication failed: \(error)"
//      case .keychainSaveFailed: "Failed to save token to keychain"
//      case .invalidAuthURL: "Invalid auth URL"
//      case .couldNotGetNewToken: "Could not get new token"
//      case .rateLimitExceeded: "Rate limit exceeded"
//      case .networkUnavailable: "Network unavailable"
//    }
//  }
//}

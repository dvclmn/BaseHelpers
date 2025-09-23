//
//  API+Token.swift
//  Collection
//
//  Created by Dave Coleman on 17/1/2025.
//

import Foundation
import KeychainSwift

//extension TokenAuthenticatable {
//
//  public var authenticationMethod: AuthenticationMethod { .token }
//
//  /// Performs token-based authentication by ensuring the request contains a valid token.
//  ///
//  /// - Parameters:
//  ///   - request: The URLRequest to be updated.
//  ///   - code: An optional code for obtaining a token.
//  /// - Throws: An error if token retrieval or header configuration fails.
//  public func authenticate(
//    _ request: inout URLRequest,
//    with code: String?
//  ) async throws {
//    print("Performing Token-based authentication for \(metadata.name) using token location: \(authLocation)")
//
//    let tokenObject = try await getToken(using: code)
//
//    print("Retrieved a valid token. Now authenticating provided request.")
//
//    print("Building headers for \(metadata.name), with token location: \(authLocation)")
//
//    switch authLocation {
//      case .headerToken:
//        let header: APIHeader = .authorization()
//        header.addToRequest(&request, secret: tokenObject.token)
//
//      case .headerTokenAndClientID:
//        print("Auth type is: \(authLocation.displayName). First checking we have a client ID")
//        guard let clientID = clientID else {
//          print("Checking if this fails.")
//          throw AuthError.missingCredentials
//        }
//
//        print("Retrieved a client ID. Now adding to headers")
//        let headerAuth: APIHeader = .authorization()
//        headerAuth.addToRequest(&request, secret: nil)
//
//        let headerClientID: APIHeader = .clientID(clientID)
//        headerClientID.addToRequest(&request, secret: nil)
//
//    //        headers.addAllToRequest(&request, with: tokenObject.token)
//    }
//  }
//
//  /// Retrieves a valid token, either from the keychain or by requesting a new one.
//  ///
//  /// - Parameter code: A code used in some APIs to obtain a token.
//  /// - Returns: A valid Token.
//  /// - Throws: An error if token retrieval fails.
//  @discardableResult
//  public func getToken(using code: String? = nil) async throws -> Token {
//    print("Attempting to retrieve a stored token or request a new one.")
//
//    /// Option 1: Check in-memory cache first
//    if let tokenData = keychain.getData(Self.tokenKey) {
//      print("Token data found in keychain.")
//      let token = try Token.fromData(tokenData)
//      print("Decoded Token from keychain data. Now checking if valid.")
//
//      switch token.isValid {
//        case true:
//          return token
//        case false:
//          /// If your API supports refreshing tokens and a refresh token exists,
//          /// you might want to call a refreshToken() function here.
//
//          //          break
//          throw AuthError.tokenHasExpired
//      }
//    }
//    print("No valid token found in keychain, fetching a new one.")
//    let url = try authURL(code: code)
//    print("Token request URL: \(url)")
//
//    let endpoint = TokenAuthenticationEndpoint<ResponseDTO>(
//      url: url,
//      method: requestMethod,
//    )
//
//    let request = APIRequestNoBody(
//      endpoint: endpoint,
//      authenticator: self,
//      secret: code
//    )
//
//    /// Fetch the token DTO from the server.
//    let response = try await request.fetch()
//    
//    
//    
//    let token = Token(token: <#T##String#>, refreshToken: <#T##String?#>, expiresIn: <#T##Int#>)
//
//    /// Save the newly retrieved token.
//    try await saveToken(token)
//
//    print("Successfully obtained and saved token from \(metadata.name)")
//    return token
//  }
//
//  /// Saves the given token into the keychain.
//  ///
//  /// - Parameter token: The token to be saved.
//  /// - Throws: An error if the token cannot be saved.
//  private func saveToken(_ token: Token) async throws {
//    let tokenData = try token.asData()
//    guard keychain.set(tokenData, forKey: Self.tokenKey) else {
//      throw AuthError.keychainSaveFailed
//    }
//  }
//
//  /// Checks if the keychain currently holds a token.
//  var doesKeychainContainToken: Bool {
//    keychain.getData(Self.tokenKey) != nil
//  }
//}

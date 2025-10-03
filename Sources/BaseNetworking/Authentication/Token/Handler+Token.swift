//
//  Handler+Token.swift
//  Networking
//
//  Created by Dave Coleman on 10/9/2025.
//

import KeychainSwift
import SwiftUI

@MainActor
//@Observable
public final class TokenHandler<DTO: Decodable> {

  public private(set) var token: AuthToken?

  public var isRefreshing: Bool = false

  private let keychain: KeychainSwift
  private let storageKey: String
  private let fetchToken: () async throws -> DTO
  private let mapToAuthToken: (DTO) -> AuthToken

  public init(
    keychain: KeychainSwift,
    storageKey: String,
    fetchToken: @escaping () async throws -> DTO,
    map: @escaping (DTO) -> AuthToken
  ) {
    self.keychain = keychain
    self.storageKey = storageKey
    self.fetchToken = fetchToken
    self.mapToAuthToken = map

    /// Load existing token if valid
    if let saved = try? loadToken(), saved.isValid {
      print("Got a valid token already. Expires: \(saved.expiryDate.formatted())")
      self.token = saved
    }

    //    startExpiryTimer()
  }
}

extension TokenHandler {

  public var isValid: Bool {
    guard let token = token else { return false }
    return token.isValid
  }

  public var shouldRefresh: Bool {
    guard let token = token else { return true }
    return token.shouldRefresh
  }

  @discardableResult
  public func getToken() async throws -> AuthToken {
    /// Return existing valid token
    if let token = token, token.isValid {
      print("Existing token is present and valid. Returning.")
      return token
    }

    /// Fetch new token
    let dto = try await fetchToken()
    let newToken = mapToAuthToken(dto)
    try saveToken(newToken)
    self.token = newToken

    print("Fetched new token. Expires: \(newToken.expiryDate.formatted())")
    return newToken
  }

  public func refreshTokenIfNeeded() async {
    guard !isRefreshing else {
      print("Already refreshing, skipping")
      return
    }
    guard shouldRefresh else {
      print("No refresh needed. Token is valid until \(token?.expiryDate.formatted() ?? "unknown")")
      return
    }

    print("Refreshing token...")
    isRefreshing = true
    defer { isRefreshing = false }

    do {
      try await getToken()
    } catch {
      print("Failed to refresh token: \(error)")
    }
  }

  private func loadToken() throws -> AuthToken {
    guard let data = keychain.getData(storageKey) else {
      throw AuthError.noTokenInKeychain
    }
    return try JSONDecoder().decode(AuthToken.self, from: data)
  }

  private func saveToken(_ token: AuthToken) throws {
    let data = try JSONEncoder().encode(token)
    keychain.set(data, forKey: storageKey, withAccess: .accessibleAfterFirstUnlock)
  }

}

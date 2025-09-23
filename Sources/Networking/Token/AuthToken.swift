//
//  Token+Object.swift
//  Collection
//
//  Created by Dave Coleman on 17/1/2025.
//

import Foundation
import BaseHelpers

/// A generic representation of an authentication token.
public struct AuthToken: Codable {
  
  /// The current token.
  public let tokenString: String
  
  /// An optional refresh token.
  public let refreshToken: String?
  
  /// When the token expires.
  public let expiryDate: Date
  
  /// The minimum amount of seconds remaining before the token should be considered expired.
  ///
  /// This "refresh margin" prevents using a token that is about to expire.
  public static let refreshMargin: TimeInterval = 300 // 5 minutes

  public init(
    token: String,
    refreshToken: String?,
    expiresIn: Int
  ) {
    self.tokenString = token
    self.refreshToken = refreshToken
    self.expiryDate = Date().addingTimeInterval(TimeInterval(expiresIn))
  }

  public var isValid: Bool {
    Date() < expiryDate
  }

  public var shouldRefresh: Bool {
    Date().addingTimeInterval(Self.refreshMargin) >= expiryDate
  }
  
  /// The time (in seconds) until the token expires.
  public var timeUntilExpiry: TimeInterval {
    max(0, expiryDate.timeIntervalSince(Date()))
  }
  
  /// A user-friendly description of how much time remains.
  public var formattedTimeRemaining: String {
    let seconds = max(0, Int(timeUntilExpiry))
//    let hours = seconds / 3600
//    let minutes = (seconds % 3600) / 60
//    return "\(hours)h \(minutes)m"
    let (h, m, s) = seconds.toHoursMinutesSeconds
    return "\(h)h \(m)m \(s)s"
  }
  
  /// Encodes the token as Data.
  ///
  /// - Returns: Encoded Data.
  /// - Throws: An encoding error.
  public func asData() throws -> Data {
    try JSONEncoder().encode(self)
  }
  
  /// Decodes an AuthToken from Data.
  ///
  /// - Parameter data: The token Data.
  /// - Returns: A valid AuthToken.
  /// - Throws: A decoding error.
  public static func fromData(_ data: Data) throws -> Self {
    try JSONDecoder().decode(Self.self, from: data)
  }
}

extension AuthToken: CustomStringConvertible {
  public var description: String {
    "AuthToken(token: \(tokenString), expiryDate: \(expiryDate))"
  }
  public var debugDescription: String {
    """
    AuthToken:
    - Token: \(tokenString.prefix(10))...
    - Refresh Token: \(refreshToken?.prefix(10) ?? "none")...
    - Expiry Date: \(expiryDate)
    - Time Remaining: \(formattedTimeRemaining)
    - Is Valid: \(isValid)
    """
  }
}

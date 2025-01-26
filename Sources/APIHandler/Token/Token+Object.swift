//
//  Token+Object.swift
//  Collection
//
//  Created by Dave Coleman on 17/1/2025.
//

import Foundation

public struct AuthToken<T: TokenDTO>: Codable {
  public typealias DTO = T
  public let token: String
  public let refreshToken: String?
  public let expiryDate: Date

  public init(from dto: DTO) {
    self.token = dto.token
    self.refreshToken = dto.refreshToken
    self.expiryDate = dto.expirationDate/// Use the already calculated date
  }

  public init(
    token: String,
    refreshToken: String? = nil,
    expiryDate: Date
  ) {
    self.token = token
    self.refreshToken = refreshToken
    self.expiryDate = expiryDate
  }

  //  public var isValid: Bool {
  //    /// Add buffer time (e.g. 5 minutes) to avoid edge cases
  //    expiryDate.timeIntervalSinceNow > 300
  //  }

  public var isValid: Bool {
    let timeRemaining = expiryDate.timeIntervalSinceNow
    let isValid = timeRemaining > 300
    print("Token validity check:")
    print("- Expiry date: \(expiryDate)")
    print("- Current date: \(Date())")
    print("- Time remaining: \(formattedTimeRemaining)")
    print("- Is valid: \(isValid)")
    return isValid
  }

  public var timeUntilExpiry: TimeInterval {
    expiryDate.timeIntervalSinceNow
  }

  public var formattedTimeRemaining: String {
    let seconds = Int(timeUntilExpiry)
    let hours = seconds / 3600
    let minutes = (seconds % 3600) / 60
    return "\(hours)h \(minutes)m"
  }

  public func asData() throws -> Data {
    try JSONEncoder().encode(self)
  }

  public static func fromData(_ data: Data) throws -> Self {
    try JSONDecoder().decode(Self.self, from: data)
  }

}

extension AuthToken: CustomStringConvertible {
  public var description: String {
    "AuthToken(token: \(token), expiryDate: \(expiryDate))"
  }
  public var debugDescription: String {
    """
    AuthToken:
    - Token: \(token.prefix(10))...
    - Refresh Token: \(refreshToken?.prefix(10) ?? "none")...
    - Expiry Date: \(expiryDate)
    - Time Remaining: \(formattedTimeRemaining)
    - Is Valid: \(isValid)
    """
  }
}

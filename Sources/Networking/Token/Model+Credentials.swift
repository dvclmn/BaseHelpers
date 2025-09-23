//
//  Model+Credentials.swift
//  Networking
//
//  Created by Dave Coleman on 10/9/2025.
//

import Foundation

/// A simple struct for credentials used for token requests.
/// These credentials should be stored as per the documentation
/// for ``APIHandler/getStringFromInfoDict(_:)``

public struct Credentials: Sendable {

  public let idKey: String
  public let secretKey: String

  public init(
    id: String,
    secret: String
  ) {
    self.idKey = id
    self.secretKey = secret
  }

  //  /// Attempts to retrieve credentials from the app’s info dictionary.
  //  ///
  //  /// - Returns: A tuple with the client ID and secret, or nil if an error occurred.
  //  public func getCredentials() -> Credentials.Values? {
  //    do {
  //      let clientID = try APIHandler.getStringFromInfoDict(clientIDKey)
  //      let clientSecret = try APIHandler.getStringFromInfoDict(clientSecretKey)
  //      return (clientID: clientID, clientSecret: clientSecret)
  //    } catch {
  //      print("Error getting credentials: \(error)")
  //      return nil
  //    }
  //  }
}

public struct ClientCredentials {
  public static func get(
    idKey: String,
    secretKey: String,
    from bundle: Bundle = .main
  ) throws -> Credentials {
    let clientID = try APIHandler.getStringFromInfoDict(idKey, bundle: bundle)
    let clientSecret = try APIHandler.getStringFromInfoDict(secretKey, bundle: bundle)
    return Credentials(
      id: clientID,
      secret: clientSecret
    )
  }
}

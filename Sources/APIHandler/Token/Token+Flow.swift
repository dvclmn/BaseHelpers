//
//  Token+Flow.swift
//  Collection
//
//  Created by Dave Coleman on 17/1/2025.
//

import Foundation

public enum TokenAuthFlow {
  /// Client credentials flow (e.g., IGDB)
  case clientCredentials(Credentials)
  
  /// Authorization code flow (e.g., GOG)
  case authorizationCode(
    credentials: Credentials,
    code: String,
    redirectURI: String
  )
  
  /// This is defined here, rather than above in the associated part,
  /// as it doesn't need to provide a value provided, it should be static
  public var grantType: String {
    switch self {
      case .clientCredentials:
        return "client_credentials"
        
      case .authorizationCode:
        return "authorization_code"
    }
  }
}

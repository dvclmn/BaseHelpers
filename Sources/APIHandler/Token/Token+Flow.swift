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
  
  public var grantType: String {
    switch self {
      case .clientCredentials:
        return "client_credentials"
        
      case .authorizationCode:
        return "authorization_code"
    }
  }
}

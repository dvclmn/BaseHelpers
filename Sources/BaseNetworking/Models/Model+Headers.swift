//
//  Model+Headers.swift
//  Networking
//
//  Created by Dave Coleman on 18/2/2025.
//

import Foundation
import BaseHelpers

//extension APIHeader {
//  public init(_ key: String, _ value: String) {
//    self.init(key: key, value: value)
//  }
//}


/// A type representing HTTP header configurations.
public enum APIHeader: Identifiable, Sendable {
  /// A header specifying the authorization value.
  /// E.g. `authorization("Bearer dh924e65g")`
  case authorization(key: String = "Authorization", prefix: AuthHeaderPrefix = .bearer)
//  case authorization(prefix: AuthHeaderPrefix = .bearer)
  
  /// A header specifying the Content-Type.
  /// E.g. `contentType(.json)`
  case contentType(MediaType)
  
  /// A header specifying the Acceptable Media Types.
  case accept([MediaType])
  
  /// A header for passing a client identifier.
  /// E.g. `clientID("jiedgoaofo9efc")`
  case clientID(String)
  
  /// A header specifying the User-Agent.
  case userAgent(String)
  
  /// A header specifying the accepted language.
  case acceptLanguage(String)
  
  /// A header specifying cache control.
  case cacheControl(CacheDirective)
  
  /// A custom header.
  case custom(key: String, value: String)
  
  func addToRequest(_ request: inout URLRequest, secret: String?) {
    request.addValue(headerValue(secret: secret), forHTTPHeaderField: headerKey)
  }
  
  public var id: String { displayName }
  
  public var displayName: String {
    switch self {
      case .authorization: "Authorisation"
      case .contentType: "Content Type"
      case .accept: "Accept"
      case .clientID: "Client ID"
      case .userAgent: "User Agent"
      case .acceptLanguage: "Accept Language"
      case .cacheControl: "Cache Control"
      case .custom: "Custom"
    }
  }
  
  var headerKey: String {
    switch self {
      case .authorization(let key, _): return key
      case .contentType: return "Content-Type"
      case .accept: return "Accept"
      case .clientID: return "Client-ID"
      case .userAgent: return "User-Agent"
      case .acceptLanguage: return "Accept-Language"
      case .cacheControl: return "Cache-Control"
      case .custom(let key, _): return key
    }
  }
  
  func headerValue(secret: String?) -> String {
    switch self {
      case .authorization(_, let prefix):
        if let secret {
          if secret.lowercased().hasPrefix(prefix.rawValue.lowercased()) {
            return secret
          } else {
            return "\(prefix.rawValue) \(secret)"
          }
        } else {
          fatalError("No secret provided for Authorization header")
        }
        
      case .contentType(let type):
        return type.rawValue
        
      case .accept(let types):
        /// Join multiple types with q-values for preference ordering
        return types.enumerated().map { index, type in
          let qValue = 1.0 - (Double(index) * 0.1)
          return "\(type.rawValue);q=\(qValue)"
        }.joined(separator: ", ")
        
      case .clientID(let id):
        return id
        
      case .userAgent(let agent):
        return agent
        
      case .acceptLanguage(let lang):
        return lang
        
      case .cacheControl(let directive):
        return directive.rawValue
        
      case .custom(_, let value):
        return value
    }
  }
}

public enum CacheDirective: String, Sendable {
  case noCache = "no-cache"
  case noStore = "no-store"
  case maxAge = "max-age"
  case `private` = "private"
  case `public` = "public"
}

extension Array where Element == APIHeader {
  /// Converts array of headers to dictionary format required by URLRequest
  public func toDictionary(with secret: String?) -> [String: String] {
    
    var headers: [String: String] = [:]
    forEach { header in
      headers[header.headerKey] = header.headerValue(secret: secret)
    }
    print("Converted `APIHeader`s to dictionary: \(headers)")
    return headers
  }
  
//  public func addAllToRequest(_ request: inout URLRequest, with secret: String?) {
//    
//    for header in self {
//      header.addToRequest(&request, secret: secret)
//    }
//  }
}

public enum MediaType: String, Sendable {
  case json = "application/json"
  case plainText = "text/plain"
  case formUrlEncoded = "application/x-www-form-urlencoded"
  case xml = "application/xml"
  case pdf = "application/pdf"
  case jpeg = "image/jpeg"
  case png = "image/png"
}

public enum AuthHeaderPrefix: Sendable {
  case bearer
  case custom(String)
  case none
  
  public var rawValue: String {
    switch self {
      case .bearer:
        return "Bearer"
       
      case .custom(let prefix):
        return prefix
        
      case .none:
        return ""
    }
  }
  
//  public func rawValue(with secret: String) -> String {
//    switch self {
//      case .bearer:
//        if secret.lowercased().hasPrefix("bearer ") {
//          return secret
//        } else {
//          return "Bearer \(secret)"
//        }
//        
//      case .custom(let prefix):
//        if secret.hasPrefix(prefix) {
//          return secret
//        } else {
//          return prefix
//        }
//    }
//  }
}

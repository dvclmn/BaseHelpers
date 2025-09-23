//
//  Model+URL.swift
//  Networking
//
//  Created by Dave Coleman on 3/3/2025.
//

import Foundation

/// Example URLs
///
/// IGDB: https://api.igdb.com/v4/external_games
/// GOG: https://embed.gog.com/account/getFilteredProducts?query=example
/// SteamGrid: https://www.steamgriddb.com/api/v2/heroes/game/
public struct RequestURL: Sendable {
  
  public var scheme: URLScheme = .https
  
  /// E.g. `embed.gog.com`
  public var host: String
  
  /// The complete path after the host but before query parameters.
  /// Includes version prefix if applicable (e.g. "/v4/external_games")
  public var endpoint: String
  
  public var parameters: URLParameters?
  
  public var urlString: String?
  
  public init(
    scheme: URLScheme,
    host: String,
    endpoint: String,
    parameters: URLParameters? = nil
  ) {
    self.scheme = scheme
    self.host = host
    self.endpoint = endpoint
    self.parameters = parameters
    self.urlString = nil
  }
  
  public init(_ urlString: String) {
    self.scheme = .https
    self.host = ""
    self.endpoint = ""
    self.parameters = nil
    self.urlString = urlString
  }
}

extension RequestURL {
  
  /// Constructs the complete URL for the request
  public func buildURL() -> URL? {
    
    if let urlString {
      return URL(string: urlString)
    }
    
    var components = URLComponents()
    components.scheme = scheme.value.replacingOccurrences(of: "://", with: "")
    components.host = host
    components.path = endpoint
    
    if let parameters = parameters {
      components.queryItems = parameters.map {
        URLQueryItem(name: $0.key, value: $0.value)
      }
    }
    let result = components.url
    print("Built `RequestURL`. Result: `\(String(describing: result))`")
    return result
  }
}


public typealias URLParameters = [String: String?]

public enum RequestMethod: String, Sendable, Codable {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case patch = "PATCH"
  case delete = "DELETE"
  
  public var value: String {
    self.rawValue
  }
}

/// Also called the protocol?
public enum URLScheme: Sendable {
  case http
  case https
  case custom(String)
  
  /// Note: This does not include `://`. This will be added
  /// automatically by the ``APIRequest/buildURL()`` method.
  public var value: String {
    switch self {
      case .http: "http"
      case .https: "https"
      case .custom(let customString): customString
    }
  }
}

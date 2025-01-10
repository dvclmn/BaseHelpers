//
//  File.swift
//  
//
//  Created by Dave Coleman on 11/8/2024.
//

import Foundation

/// # HTTP Error Code Classes
/// 100s: Informational codes. Indicating that the request initiated by the browser is continuing
/// 200s: Success codes. Returned when browser request was received, understood, and processed by the server
/// 300s: Redirection codes. Returned when a new resource has been substituted for the requested resource
/// 400s: Client error codes. Indicating that there was a problem with the request
/// 500s: Server error codes. Indicating that the request was accepted, but that an error on the server prevented the fulfillment of the request
///
public enum APIError: Error, LocalizedError {
  
  case invalidResponse
  case unauthorized
  case forbidden
  case notFound
  case serverError(Int)
  case noInternetConnection
  case networkConnectionLost
  case dnsLookupFailed
  case timeout
  case unknownStatusCode(Int)
  case badURL
  case badRequest(Data)
  case cannotFindHost
  case cannotConnectToHost
  case parsingError
  case decodingError(Error)
  case bodyEncodeError
  
  case otherError(Error)
  
  public var errorDescription: String? {
    switch self {
        //        case .connectionError(let type):
        //            return "Connection error with \(type)"
      case .parsingError:
        return "Failed to parse data"
      case .otherError(let message):
        return message.localizedDescription
      default:
        return "Default error message"
    }
  }
  
  public var recoverySuggestion: String? {
    switch self {
        //        case .connectionError:
        //            return "Check your internet connection and try again"
      case .parsingError:
        return "Please report this issue"
      case .otherError:
        return "Refer to detailed error message"
      default:
        return "Default recovery message"
    }
  }
}


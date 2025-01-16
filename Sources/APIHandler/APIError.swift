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
  
  case badURL
  case parsingError
  case bodyEncodeError
  case invalidResponse(String)
  case decodingError(Error)
  case badRequest(Data)
  case unauthorized(String? = nil)
  case forbidden
  case notFound
  case serverError(Int)
  case noInternetConnection
  case networkConnectionLost
  case dnsLookupFailed
  case cannotFindHost
  case cannotConnectToHost
  case timeout
  case otherError(Error)
  case unknownStatusCode(Int)
  case invalidContentType(String)
  case couldNotGetContentTypeHeader
  case couldNotCastAsHTTPURLResponse
//  case urlError(URLError)
  
  public var errorDescription: String? {
    switch self {
      case .invalidResponse(let description):
        return "Invalid response from server: \(description)"
      case .decodingError(let error):
        return "Failed to decode response: \(error)"
      case .badRequest(let data):
        return "Bad request: \(String(data: data, encoding: .utf8) ?? "No details")"
      case .unauthorized(let message):
        return "Unauthorized: \(message ?? "Invalid or expired token")"
      case .forbidden:
        return "Access forbidden"
      case .notFound:
        return "Resource not found"
      case .serverError(let code):
        return "Server error (\(code))"
      case .noInternetConnection:
        return "No internet connection"
      case .networkConnectionLost:
        return "Network connection lost"
      case .dnsLookupFailed:
        return "DNS lookup failed"
      case .cannotFindHost:
        return "Cannot find host"
      case .cannotConnectToHost:
        return "Cannot connect to host"
      case .timeout:
        return "Request timed out"
      case .unknownStatusCode(let code):
        return "Unknown status code: \(code)"
      case .otherError(let error):
        return "Other error: \(error)"
      case .badURL:
        return "Bad URL"
      case .parsingError:
        return "Parsing Error"
      case .bodyEncodeError:
        return "Body Encode Error"
      case .invalidContentType(let data):
        return "Invalid content type: \(data)"

    }
  }
//  public var errorDescription: String? {
//    switch self {
//        //        case .connectionError(let type):
//        //            return "Connection error with \(type)"
//      case .parsingError:
//        return "Failed to parse data"
//      case .otherError(let message):
//        return message
//      default:
//        return "Default error message"
//    }
//  }
  
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


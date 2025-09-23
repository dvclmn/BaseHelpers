//
//  File.swift
//  
//
//  Created by Dave Coleman on 11/8/2024.
//

import Foundation

public enum APIError: Error, LocalizedError {
  
  case unauthorized(String)
  case badRequest(String)
  case forbidden(String)
  case notFound(String)
  case serverError(Int, String)
  case unknownStatusCode(Int, String)
  case badURL
  case parsingError
  case bodyEncodeError
  case invalidResponse(String)
  case decodingError(String)
//  case decodingError(Error)
  case noInternetConnection
  case networkConnectionLost
  case dnsLookupFailed
  case cannotFindHost
  case cannotConnectToHost
  case timeout
  case otherError(Error)
  case invalidContentType(String)
  case couldNotGetContentTypeHeader
  case couldNotCastAsHTTPURLResponse
  
  public var errorDescription: String {
    switch self {
      case .unauthorized(let string): "Unauthorized: \(string)"
      case .badRequest(let string): "Bad Request: \(string)"
      case .forbidden(let string): "Forbidden? \(string)"
      case .notFound(let string): "Not found: \(string)"
      case .serverError(let int, let string): "Server Error: \(int): \(string)"
      case .unknownStatusCode(let int, let string): "Unknown Status Code: \(int): \(string)"
      case .badURL: "Bad URL"
      case .parsingError: "Parse error"
      case .bodyEncodeError: "Body encode error"
      case .invalidResponse(let string): "Invalid response: \(string)"
      case .decodingError(let string): "Decoding Error: \(string)"
      case .noInternetConnection: "No internet connection"
      case .networkConnectionLost: "Network connection lost"
      case .dnsLookupFailed: "DNS Lookup failed"
      case .cannotFindHost: "Cannot find host"
      case .cannotConnectToHost: "Cannot connect to host"
      case .timeout: "Timeout"
      case .otherError(let error): "Other Error: \(error)"
      case .invalidContentType(let string): "Invalid Content Type: \(string)"
      case .couldNotGetContentTypeHeader: "Could not get Content-Type header"
      case .couldNotCastAsHTTPURLResponse: "Could not cast as HTTPURLResponse"
    }
  }

//  public var errorDescription: String? {
//    switch self {
//      case .invalidResponse(let description):
//        return "Invalid response from server: \(description)"
//      case .decodingError(let error):
//        return "Failed to decode response: \(error)"
//      case .badRequest(let data):
//        return "Bad request: \(String(data: data, encoding: .utf8) ?? "No details")"
//        
//      case .unauthorized(let message):
//        return "Unauthorized: \(message ?? "Invalid or expired token")"
//      case .forbidden:
//        return "Access forbidden"
//      case .notFound:
//        return "Resource not found"
//      case .serverError(let code):
//        return "Server error (\(code))"
//      case .noInternetConnection:
//        return "No internet connection"
//      case .networkConnectionLost:
//        return "Network connection lost"
//      case .dnsLookupFailed:
//        return "DNS lookup failed"
//      case .cannotFindHost:
//        return "Cannot find host"
//      case .cannotConnectToHost:
//        return "Cannot connect to host"
//      case .timeout:
//        return "Request timed out"
//      case .unknownStatusCode(let code):
//        return "Unknown status code: \(code)"
//      case .otherError(let error):
//        return "Other error: \(error)"
//      case .badURL:
//        return "Bad URL"
//      case .parsingError:
//        return "Parsing Error"
//      case .bodyEncodeError:
//        return "Body Encode Error"
//      case .invalidContentType(let data):
//        return "Invalid content type: \(data)"
//        
//      case .couldNotGetContentTypeHeader:
//        return "Could not get content type header"
//      case .couldNotCastAsHTTPURLResponse:
//        return "Could not cast URL response to HTTPURLResponse"
//
//    }
//  }
}

extension APIError: CustomStringConvertible {
  public var description: String {
    errorDescription
  }
}

public enum AuthError: LocalizedError {
  case invalidURL
  case noCallbackURL
  case failedToExtractSteamID
  case missingCredentials
  case tokenHasExpired
  case keychainSaveFailed
  case keychainDeleteFailed
  case notAuthorised
  case noTokenInKeychain
  case noTokenFound
  
  public var errorDescription: String? {
    switch self {
      case .invalidURL: "Invalid authentication URL"
      case .noCallbackURL: "No callback URL received"
      case .failedToExtractSteamID: "Failed to extract Steam ID"
      case .missingCredentials: "Missing credentials"
      case .tokenHasExpired: "Token has expired"
      case .keychainSaveFailed: "Keychain save failed"
      case .keychainDeleteFailed: "Keychain delete failed"
      case .notAuthorised: "Not Authorised"
      case .noTokenInKeychain: "No Token in Keychain"
      case .noTokenFound: "No Token Found"
    }
  }
}

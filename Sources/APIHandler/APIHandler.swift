//
//  File.swift
//
//
//  Created by Dave Coleman on 14/5/2024.
//

import Foundation
import OSLog

public protocol APIProvider {
//  associatedtype Method = AuthMethod
//  var authMethod: Method { get }
}

/// Statically pre-generated API Keys
public protocol KeyAuth {

  static var apiKeyKey: String { get }

  /// Is the API Key required to be added to the URL as a parameter,
  /// e.g. `https://example.com/api/v2?key=12345`
  /// or the Request headers, as `Authorization : Bearer 12345`
  ///
  /// Note: This is made a `static` property, as it should be determined
  /// at compile time, not changed at runtime etc.
  static var authLocation: APIKeyAuthLocation { get }
}

public struct Credentials {
  public let clientID: String
  public let clientSecret: String
}


public enum APIKeyAuthLocation {
  case header // E.g. SteamGrid
  case queryParameter // E.g. Steam
}

//public enum AuthMethod {
//  case token(TokenAuth)
//  case apiKey(KeyAuth)
//}

// First, let's define different auth flows
public enum AuthFlow {
  /// Client credentials flow (e.g., IGDB)
  case clientCredentials(clientID: String, clientSecret: String)
  /// Authorization code flow (e.g., GOG)
  case authorizationCode(
    clientID: String,
    clientSecret: String,
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


public struct APIHandler: Sendable {

  public static func encodeBody<T: Encodable>(_ body: T) -> Data? {
    do {
      let encoder = JSONEncoder()
      let jsonData = try encoder.encode(body)
      return jsonData
    } catch {
      print("Failed to encode request body: \(error)")
      return nil
    }
  }

}

extension URLRequest {
  public func printPrettyString() -> String {
    var requestComponents = [String: Any]()

    if let url = self.url {
      requestComponents["URL"] = url.absoluteString
    }

    if let method = self.httpMethod {
      requestComponents["Method"] = method
    }

    if let headers = self.allHTTPHeaderFields {
      requestComponents["Headers"] = headers
    }

    if let body = self.httpBody, let bodyString = String(data: body, encoding: .utf8) {
      // Attempt to serialize JSON body to a readable JSON String
      if let jsonObject = try? JSONSerialization.jsonObject(with: body, options: []),
        let prettyPrintedData = try? JSONSerialization.data(
          withJSONObject: jsonObject, options: [.prettyPrinted]),
        let prettyPrintedString = String(data: prettyPrintedData, encoding: .utf8)
      {
        requestComponents["Body"] = prettyPrintedString
      } else {
        // If body is not JSON or not decodable, print as a string
        requestComponents["Body"] = bodyString
      }
    }

    guard
      let jsonData = try? JSONSerialization.data(
        withJSONObject: requestComponents, options: [.prettyPrinted]),
      let jsonString = String(data: jsonData, encoding: .utf8)
    else {
      return "Didn't work"
    }
    return jsonString
  }
}


public enum APIRequestType: String, Sendable, Codable {
  case get
  case post

  public var value: String {
    switch self {
      case .get:
        "GET"
      case .post:
        "POST"
    }
  }
}


enum ConfigError: Error {
  case missingKey(String)
  case invalidValue(String)
}



//os_log(
//  "Looks like the fetch request worked. This function will now send the raw data to be processed."
//)
//do {
//  // Pretty print the raw response data for debugging
//  if isDebugMode {
//    do {
//      let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
//      let prettyData = try JSONSerialization.data(
//        withJSONObject: jsonObject, options: [.prettyPrinted, .sortedKeys])
//      let prettyString = String(data: prettyData, encoding: .utf8)
//      os_log("Raw response data:\n\(prettyString ?? "Couldn't pretty print JSON")")
//      
//    } catch {
//      // Fallback to raw string if JSON parsing fails
//      if let responseString = String(data: data, encoding: .utf8) {
//        os_log("Raw response data (not valid JSON):\n\(responseString)")
//      }
//    }
//  }
//  
//  let decoder = JSONDecoder()
//  decoder.keyDecodingStrategy = .convertFromSnakeCase  // If needed
//  
//  do {
//    return try decoder.decode(T.self, from: data)
//  } catch let decodingError as DecodingError {
//    switch decodingError {
//      case .dataCorrupted(let context):
//        os_log(
//                    """
//                    DTO: \(T.self)
//                    Data corrupted error:
//                    Debug description: \(context.debugDescription)
//                    Coding path: \(context.codingPath)
//                    Underlying error: \(String(describing: context.underlyingError))
//                    Raw data: \(String(data: data, encoding: .utf8) ?? "Unable to convert data to string")
//                    """)
//        
//      case .keyNotFound(let key, let context):
//        os_log(
//                    """
//                    DTO: \(T.self)
//                    Key not found error:
//                    Missing key: \(key.stringValue)
//                    Debug description: \(context.debugDescription)
//                    Coding path: \(context.codingPath)
//                    """)
//        
//      case .typeMismatch(let type, let context):
//        os_log(
//                    """
//                    DTO: \(T.self)
//                    Type mismatch error:
//                    Expected type: \(type)
//                    Debug description: \(context.debugDescription)
//                    Coding path: \(context.codingPath)
//                    """)
//        
//      case .valueNotFound(let type, let context):
//        os_log(
//                    """
//                    DTO: \(T.self)
//                    Value not found error:
//                    Expected type: \(type)
//                    Debug description: \(context.debugDescription)
//                    Coding path: \(context.codingPath)
//                    """)
//        
//      @unknown default:
//        os_log("Unknown decoding error: \(decodingError)")
//    }
//    throw APIError.decodingError(decodingError)
//  }
//} catch {
//  os_log("Unexpected error during decoding: \(error)")
//  throw APIError.decodingError(error)
//}
//
////
////          os_log("Looks like the fetch request worked. This function will now send the raw data to be processed.")
////          do {
////            let decoder = JSONDecoder()
////            return try decoder.decode(T.self, from: data)
////          } catch {
////            os_log("Decoding error: \(error)")
////            throw APIError.decodingError(error)
////          }
////

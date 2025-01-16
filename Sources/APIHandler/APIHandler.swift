//
//  File.swift
//
//
//  Created by Dave Coleman on 14/5/2024.
//

import Foundation
import OSLog

public protocol APIResponse: Decodable, Sendable {}

public protocol APIRequestBody: Encodable, Sendable {}

public protocol APIUsage: Decodable, Sendable {}

public protocol StreamedResponse: Decodable, Sendable {
  var responseData: StreamedResponseMessage? { get }
  var usage: StreamedResponseUsage? { get }
}

public extension StreamedResponse {
  /// Sets to `nil` as default
  var responseData: StreamedResponseMessage? { nil }
  var usage: StreamedResponseUsage? { nil }
}

public protocol StreamedResponseMessage: Decodable, Sendable {
  var text: String? { get }
  var usage: StreamedResponseUsage? { get }
}
public extension StreamedResponseMessage {
  var text: String? { nil }
  var usage: StreamedResponseUsage? { nil }
}

public protocol StreamedResponseUsage: Decodable, Sendable {
  var input_tokens: Int? { get }
  var output_tokens: Int? { get }
}
public extension StreamedResponseMessage {
  var input_tokens: Int? { nil }
}

public struct APIHandler: Sendable {
  
  
  /// This requires the following set-up:
  ///
  /// 1. Add `Config.xcconfig` file to project
  /// 2. Add sensitive data e.g. `STEAM_SECRET = 4620doa8408...`
  ///   IMPORTANT: For this to work, do *not* surround the value in `"`
  ///   Just leave it bare, as it is above
  ///
  /// 3. Ensure this config file is not added to source control (ignored)
  /// 4. Add the config file to the project via Project Settings > Info > Configurations,
  ///   in the Debug dropdown. Just to the project, not the target(s).
  /// 5. Finally, add each reference to sensitive data to the `Info.plist`, like so:
  /// ```
  /// <key>SteamSecret</key>
  /// <string>$(STEAM_SECRET)</string>
  /// ```
  /// 6. The above `key` is what you provide to the below `key` parameter
  ///
  public static func getStringFromInfoDict(_ key: String) throws -> String {
    
    
    guard let result = Bundle.main.object(forInfoDictionaryKey: key) as? String else {
      throw ConfigError.missingKey(key)
    }
    guard !result.isEmpty else {
      throw ConfigError.invalidValue(key)
    }
    return result
  }
  
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
  
  // MARK: - Generic API fetch
  /// Makes a network request — Does NOT decode the response
  public static func fetch<T: Decodable>(request: URLRequest) async throws -> T {
    os_log("""
        
        "Going to fetch and return Decodable data of type \(T.Type.self), using supplied request.
        Request method: \(request.httpMethod?.debugDescription ?? "Can't get HTTP method")
        Request URL: \(request.url?.absoluteString ?? "Can't get URL")
        Request Body: \(request.httpBody?.debugDescription ?? "nil Body")
        Request Headers: \(request.allHTTPHeaderFields?.description ?? "nil Headers")
        """
    )
    do {
      
      
      let (data, response) = try await URLSession.shared.data(for: request)
      
      
      
      // Ensure the response is valid
      guard let httpResponse = response as? HTTPURLResponse else {
        os_log("Hmm, couldn't recognise the response as a typical `HTTPURLResponse`. Here it is anyway: \(response.debugDescription)")
        throw APIError.invalidResponse
      }
      
      if let contentType = httpResponse.value(forHTTPHeaderField: "Content-Type") {
        if !contentType.contains("application/json") {
          os_log("Unexpected content type: \(contentType)")
          if let responseString = String(data: data, encoding: .utf8) {
            os_log("Response body: \(responseString)")
          }
          throw APIError.invalidContentType(contentType)
        }
      }
      
      switch httpResponse.statusCode {
        case 200...299:
          os_log("Looks like the fetch request worked. This function will now send the raw data to be processed.")
          do {
            // Print the raw response data for debugging
            if let responseString = String(data: data, encoding: .utf8) {
              os_log("Raw response data: \(responseString)")
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase // If needed
            
            do {
              return try decoder.decode(T.self, from: data)
            } catch let decodingError as DecodingError {
              switch decodingError {
                case .dataCorrupted(let context):
                  os_log("""
                    Data corrupted error:
                    Debug description: \(context.debugDescription)
                    Coding path: \(context.codingPath)
                    Underlying error: \(String(describing: context.underlyingError))
                    Raw data: \(String(data: data, encoding: .utf8) ?? "Unable to convert data to string")
                    """)
                  
                case .keyNotFound(let key, let context):
                  os_log("""
                    Key not found error:
                    Missing key: \(key.stringValue)
                    Debug description: \(context.debugDescription)
                    Coding path: \(context.codingPath)
                    """)
                  
                case .typeMismatch(let type, let context):
                  os_log("""
                    Type mismatch error:
                    Expected type: \(type)
                    Debug description: \(context.debugDescription)
                    Coding path: \(context.codingPath)
                    """)
                  
                case .valueNotFound(let type, let context):
                  os_log("""
                    Value not found error:
                    Expected type: \(type)
                    Debug description: \(context.debugDescription)
                    Coding path: \(context.codingPath)
                    """)
                  
                @unknown default:
                  os_log("Unknown decoding error: \(decodingError)")
              }
              throw APIError.decodingError(decodingError)
            }
          } catch {
            os_log("Unexpected error during decoding: \(error)")
            throw APIError.decodingError(error)
          }
          
//
//          os_log("Looks like the fetch request worked. This function will now send the raw data to be processed.")
//          do {
//            let decoder = JSONDecoder()
//            return try decoder.decode(T.self, from: data)
//          } catch {
//            os_log("Decoding error: \(error)")
//            throw APIError.decodingError(error)
//          }
//          
        case 400:
          os_log("Bad Request: \(String(data: data, encoding: .utf8) ?? "")")
          throw APIError.badRequest(data)
        case 401:
          throw APIError.unauthorized(httpResponse.description)
        case 403:
          throw APIError.forbidden
        case 404:
          throw APIError.notFound
        case 500...599:
          throw APIError.serverError(httpResponse.statusCode)
        default:
          os_log("Unknown status code: \(httpResponse.statusCode)")
          throw APIError.unknownStatusCode(httpResponse.statusCode)
      }
    } catch let error as URLError {
      os_log("URLError: \(error)")
      switch error.code {
        case .notConnectedToInternet:
          throw APIError.noInternetConnection
        case .networkConnectionLost:
          throw APIError.networkConnectionLost
        case .dnsLookupFailed:
          throw APIError.dnsLookupFailed
        case .cannotFindHost:
          throw APIError.cannotFindHost
        case .cannotConnectToHost:
          throw APIError.cannotConnectToHost
        case .timedOut:
          throw APIError.timeout
        default:
          throw APIError.otherError(error)
      }
    } catch let apiError as APIError {
      throw apiError
    } catch {
      os_log("Unexpected error: \(error)")
      throw APIError.otherError(error)
    }
  } // END API fetch
  
}


public extension URLRequest {
  func printPrettyString() -> String {
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
         let prettyPrintedData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
         let prettyPrintedString = String(data: prettyPrintedData, encoding: .utf8) {
        requestComponents["Body"] = prettyPrintedString
      } else {
        // If body is not JSON or not decodable, print as a string
        requestComponents["Body"] = bodyString
      }
    }
    
    if let jsonData = try? JSONSerialization.data(withJSONObject: requestComponents, options: [.prettyPrinted]),
       let jsonString = String(data: jsonData, encoding: .utf8) {
      return jsonString
    } else {
      return "Didn't work"
    }
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

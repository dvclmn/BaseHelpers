//
//  File.swift
//
//
//  Created by Dave Coleman on 14/5/2024.
//

import Foundation
import OSLog
//import BaseUtilities


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


@MainActor
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
  
  public static func createRequest(
    url: URL?,
    headers: [String : String]
  ) throws -> URLRequest? {
    
    os_log("Let's make a URLRequest — no body needed, just url and headers")
    
    guard let url = url else {
      print("Invalid URL")
      return nil
    }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    for (key, value) in headers {
      request.setValue(value, forHTTPHeaderField: key)
    }
    return request
  }
  
  public static func createRequest<T: Encodable>(
    url: URL?,
    body: T,
    headers: [String : String]
  ) throws -> URLRequest? {
    
    os_log("Let's make a URLRequest, with a body")
    
    guard let url = url else {
      print("Invalid URL")
      return nil
    }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    let encoder = JSONEncoder()
    let data = try encoder.encode(body)
    request.httpBody = data
    
    os_log("""
        Request Body: \(request.httpBody?.debugDescription ?? "")
        """
    )
    
    for (key, value) in headers {
      request.setValue(value, forHTTPHeaderField: key)
    }
    return request
  }
  
  // MARK: - Generic API fetch
  /// Makes a network request — Does NOT decode the response
  public static func fetch<T: Decodable>(request: URLRequest) async throws -> T {
    os_log("""
        
        "Going to fetch and return Decodable data, using supplied request.
        Request method: \(request.httpMethod?.debugDescription ?? "Can't get HTTP method")
        Request URL: \(request.url?.description ?? "Can't get URL")
        Request Body: \(request.httpBody?.debugDescription ?? "Can't get body")
        Request Headers: \(request.allHTTPHeaderFields?.description ?? "nil headers")
        """
    )
    do {
      let (data, response) = try await URLSession.shared.data(for: request)
      
      // Ensure the response is valid
      guard let httpResponse = response as? HTTPURLResponse else {
        os_log("Hmm, couldn't recognise the response as a typical `HTTPURLResponse`. Here it is anyway: \(response.debugDescription)")
        throw APIError.invalidResponse
      }
      
      switch httpResponse.statusCode {
        case 200...299:
          os_log("Looks like the fetch request worked. This function will now send the raw data to be processed.")
          do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
          } catch {
            os_log("Decoding error: \(error.localizedDescription)")
            throw APIError.decodingError(error)
          }
          
        case 400:
          os_log("Bad Request: \(String(data: data, encoding: .utf8) ?? "")")
          throw APIError.badRequest(data)
        case 401:
          throw APIError.unauthorized
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
      os_log("URLError: \(error.localizedDescription)")
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
      os_log("Unexpected error: \(error.localizedDescription)")
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
  
  var value: String {
    switch self {
      case .get:
        "GET"
      case .post:
        "POST"
    }
  }
}


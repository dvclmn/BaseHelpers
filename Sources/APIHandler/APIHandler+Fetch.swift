//
//  APIHandler+Fetch.swift
//  Collection
//
//  Created by Dave Coleman on 16/1/2025.
//

import Foundation

extension APIHandler {

  public static func requestAndFetch<T: Decodable>(
    url: URL?,
    body: (any Encodable)? = nil,
    headers: [String: String] = [:],
    dto: T.Type,
    isDebugMode: Bool = false
  ) async throws -> T {

    if isDebugMode {

      print(
        """

        /// Request & Fetch ///

        DTO: \(dto)

        # Request
        URL: \(url?.absoluteString ?? "nil")
        Body: \(body ?? "nil")
        Headers: \(headers.prettyPrinted())

        """)
    }

    let request = try createRequest(
      url: url,
      body: body,
      headers: headers
    )
    let response: T = try await fetch(
      request: request,
      isDebugMode: isDebugMode
    )
//
//    print(
//      """
//
//      # Fetched Response
//        
//        
//
//      """)

    return response
  }

  // MARK: - Generic API fetch

  public static func fetch<T: Decodable>(
    request: URLRequest,
    /// This produces more verbose print statements
    isDebugMode: Bool = false
  ) async throws -> T {

    let (data, response) = try await URLSession.shared.data(for: request)

    let httpResponse = try validateHTTPResponse(response)
    try checkContentTypeIsJSON(data: data, response: response)
    try validateStatusCode(httpResponse, data: data)

    return try decodeResponse(data: data, type: T.self, isDebugMode: isDebugMode)

  }  // END API fetch

  
  private static func decodeResponse<T: Decodable>(
    data: Data,
    type: T.Type,
    isDebugMode: Bool
  ) throws -> T {
    if isDebugMode {
      
      
//        if let jsonString = String(data: data, encoding: .utf8) {
//          print("Decoding JSON: \(jsonString)")
//        } else {
//          print("Failed to convert data to string.")
//        }
//

      
      printDebugResponse(data)
    }
    
    let decoder = JSONDecoder()
//    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    do {
      return try decoder.decode(T.self, from: data)
    } catch let decodingError as DecodingError {
      handleDecodingError(decodingError, type: T.self, data: data)
      throw APIError.decodingError(decodingError)
    } catch {
      print("Unexpected error during decoding: \(error)")
      throw APIError.decodingError(error)
    }
  }
  
  
  
  private static func printDebugResponse(_ data: Data) {
    do {
      let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
      let prettyData = try JSONSerialization.data(
        withJSONObject: jsonObject,
        options: [.prettyPrinted, .sortedKeys]
      )
      let prettyString = String(data: prettyData, encoding: .utf8)
      print("Raw response data:\n\(prettyString ?? "Couldn't pretty print JSON")")
    } catch {
      if let responseString = String(data: data, encoding: .utf8) {
        print("Raw response data (not valid JSON):\n\(responseString)")
      }
    }
  }

  private static func handleDecodingError(
    _ error: DecodingError,
    type: Any.Type,
    data: Data
  ) {
    switch error {
      case .dataCorrupted(let context):
        print("""
        DTO: \(type)
        Data corrupted error:
        Debug description: \(context.debugDescription)
        Coding path: \(context.codingPath)
        Underlying error: \(String(describing: context.underlyingError))
        Raw data: \(String(data: data, encoding: .utf8) ?? "Unable to convert data to string")
        """)
        
      case .keyNotFound(let key, let context):
        print("""
        DTO: \(type)
        Key not found error:
        Missing key: \(key.stringValue)
        Debug description: \(context.debugDescription)
        Coding path: \(context.codingPath)
        """)
        
      case .typeMismatch(let type, let context):
        print("""
        DTO: \(type)
        Type mismatch error:
        Expected type: \(type)
        Debug description: \(context.debugDescription)
        Coding path: \(context.codingPath)
        """)
        
      case .valueNotFound(let type, let context):
        print("""
        DTO: \(type)
        Value not found error:
        Expected type: \(type)
        Debug description: \(context.debugDescription)
        Coding path: \(context.codingPath)
        """)
        
      @unknown default:
        print("Unknown decoding error: \(error)")
    }
  }
  
  

  static func checkContentTypeIsJSON(
    data: Data,
    response: URLResponse
  ) throws {

    guard let httpResponse = response as? HTTPURLResponse else {
      throw APIError.couldNotCastAsHTTPURLResponse
    }

    guard let contentType = httpResponse.value(forHTTPHeaderField: "Content-Type") else {
      throw APIError.couldNotGetContentTypeHeader
    }

    guard contentType.contains("application/json") else {
      print(printNonJSONData(data: data))
      throw APIError.invalidContentType(contentType)
    }
  }
  
  
  
  private static func validateHTTPResponse(_ response: URLResponse) throws -> HTTPURLResponse {
    guard let httpResponse = response as? HTTPURLResponse else {
      throw APIError.invalidResponse(response.debugDescription)
    }
    return httpResponse
  }
  
  private static func validateStatusCode(_ response: HTTPURLResponse, data: Data) throws {
    switch response.statusCode {
      case 200...299:
        return
      case 400:
        throw APIError.badRequest(data)
      case 401:
        throw APIError.unauthorized(response.description)
      case 403:
        throw APIError.forbidden
      case 404:
        throw APIError.notFound
      case 500...599:
        throw APIError.serverError(response.statusCode)
      default:
        throw APIError.unknownStatusCode(response.statusCode)
    }
  }

  static func printNonJSONData(data: Data) -> String {
    guard let dataAsString = String(data: data, encoding: .utf8) else {
      return "nil"
    }
    return dataAsString
  }

}

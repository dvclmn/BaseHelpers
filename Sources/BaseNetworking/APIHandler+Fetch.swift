//
//  APIHandler+Fetch.swift
//  Collection
//
//  Created by Dave Coleman on 16/1/2025.
//

import BaseHelpers
import Foundation

extension APIRequest {
  //  @MainActor
  func fetch(request: URLRequest) async throws -> T {

    let (data, response) = try await URLSession.shared.data(for: request)

    let httpResponse = try Self.validateHTTPResponse(response)
    try Self.checkContentTypeIsJSON(data: data, response: httpResponse)
    try Self.validateStatusCode(httpResponse, data: data)
    printPadded("About to decode response:")
    return try Self.decodeResponse(data: data, type: T.self)
    //    return try decodeResponse(data: data, type: T.self, isDebugMode: isDebugMode)

  }  // END API fetch

  private static func decodeResponse(
    data: Data,
    type: T.Type,
  ) throws -> T {
    
    print("Decoding response, with type `\(T.self)`")
    let decoder = JSONDecoder()

    do {
      return try decoder.decode(T.self, from: data)
    } catch let decodingError as DecodingError {
      print("There was a decoding error: \(decodingError)")
      let errorString = generateDecodingErrorString(
        decodingError,
        type: T.self,
        data: data
      )
      throw APIError.decodingError(errorString)
    } catch {
      print("Unexpected error during decoding: \(error)")
      throw APIError.decodingError(error.localizedDescription)
    }
  }

  private static func printDebugResponse(_ data: Data) {
    let debugString = data.prettyPrintedJSONString
    print("Raw response data:\n\(debugString)")
  }

  private static func generateDecodingErrorString(
    _ error: DecodingError,
    type: T.Type,
    data: Data
  ) -> String {

    return """
      DTO: \(type)
      Decoding Error: \(error.name)
      Raw data: \(String(data: data, encoding: .utf8) ?? "Unable to convert data to string")
      """

  }

  private static func validateHTTPResponse(_ response: URLResponse) throws -> HTTPURLResponse {
    guard let httpResponse = response as? HTTPURLResponse else {
      throw APIError.invalidResponse(response.debugDescription)
    }
    return httpResponse
  }

  static func checkContentTypeIsJSON(
    data: Data,
    response: HTTPURLResponse
  ) throws {

    guard let contentType = response.value(forHTTPHeaderField: "Content-Type") else {
      throw APIError.couldNotGetContentTypeHeader
    }

    guard contentType.contains("application/json") else {
      print("Non-JSON content type:\n" + printNonJSONData(data: data))
      throw APIError.invalidContentType(contentType)
    }
  }
  static func printNonJSONData(data: Data) -> String {
    guard let dataAsString = String(data: data, encoding: .utf8) else {
      return "nil"
    }
    return dataAsString
  }

  private static func validateStatusCode(_ response: HTTPURLResponse, data: Data) throws {
    switch response.statusCode {

      case 200...299:
        return

      case 400:
        let errorMessage = createErrorMessage(response: response, data: data)
        throw APIError.badRequest(errorMessage)

      case 401:
        let errorMessage = createErrorMessage(response: response, data: data)
        throw APIError.unauthorized(errorMessage)

      case 403:
        let errorMessage = createErrorMessage(response: response, data: data)
        throw APIError.forbidden(errorMessage)

      case 404:
        let errorMessage = createErrorMessage(response: response, data: data)
        throw APIError.notFound(errorMessage)

      case 500...599:
        let errorMessage = createErrorMessage(response: response, data: data)
        throw APIError.serverError(response.statusCode, errorMessage)

      default:
        let errorMessage = createErrorMessage(response: response, data: data)
        throw APIError.unknownStatusCode(response.statusCode, errorMessage)
    }
  }

  private static func createErrorMessage(
    response: HTTPURLResponse,
    data: Data
  ) -> String {
    let urlString = response.url?.absoluteString ?? "Unknown URL"

    /// Format headers in a more readable way
    let headersString = response.allHeaderFields
      .map { " -- \($0.key): \($0.value)" }
      .joined(separator: "\n")

    // Try to parse JSON for better formatting
    let bodyString: String
    if let json = try? JSONSerialization.jsonObject(with: data),
      let prettyData = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted, .sortedKeys]),
      let prettyString = String(data: prettyData, encoding: .utf8)
    {
      bodyString = prettyString
    } else {
      bodyString = String(data: data, encoding: .utf8) ?? "Unable to decode body"
    }

    let output = """
      ┌─────────────────────────────────────────────
      │ 🛑 API ERROR (\(response.statusCode))
      ├─────────────────────────────────────────────
      │ URL: \(urlString)
      ├─────────────────────────────────────────────
      │ BODY:
      │   \(bodyString.split(separator: "\n").joined(separator: "\n│   "))
      └─────────────────────────────────────────────
      """

    //    let output = """
    //      ┌─────────────────────────────────────────────
    //      │ 🛑 API ERROR (\(response.statusCode))
    //      ├─────────────────────────────────────────────
    //      │ URL: \(urlString)
    //      ├─────────────────────────────────────────────
    //      │ HEADERS:
    //      \(headersString.split(separator: "\n").map { "│   \($0)" }.joined(separator: "\n"))
    //      ├─────────────────────────────────────────────
    //      │ BODY:
    //      │   \(bodyString.split(separator: "\n").joined(separator: "\n│   "))
    //      └─────────────────────────────────────────────
    //      """

    return output
  }

  //  private static func createErrorMessage(response: HTTPURLResponse, data: Data) -> String {
  //
  //    let urlString = response.url?.absoluteString ?? "Unknown URL"
  //
  //    /// Format headers as key-value pairs with line breaks
  //    let headersString = response.allHeaderFields
  //      .map { "  \($0.key): \($0.value)" }
  //      .joined(separator: "\n")
  //
  //    let bodyString = data.debugString
  //
  //    return """
  //
  //      /// APIHandler Error ///
  //      Error \(response.statusCode)
  //      URL: \(urlString)
  //      Headers: \(headersString)
  //      Body:
  //      \(bodyString)
  //
  //      /// END ///
  //
  //
  //      """
  //  }

}

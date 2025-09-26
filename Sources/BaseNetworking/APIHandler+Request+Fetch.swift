//
//  File.swift
//
//
//  Created by Dave Coleman on 14/5/2024.
//

import BaseHelpers
import Foundation

public struct APIHandler: Sendable {

  public static func requestAndFetch<T: Decodable>(
    url: URL?,
    method: RequestMethod,
    body: (any Encodable)? = nil,
    headers: [String: String]? = nil,
    dto: T.Type,
    isDebugMode: Bool = false
  ) async throws -> T {

    if isDebugMode {
      let pretty = composePrettyString(url: url, method: method, body: body, headers: headers, dto: dto)
      printPadded(pretty)
    }

    let request = try createRequest(
      url: url,
      method: method,
      body: body,
      headers: headers
    )
    let response: T = try await fetch(
      request: request,
      isDebugMode: isDebugMode
    )
    return response
  }

  private static func composePrettyString<T: Decodable>(
    url: URL?,
    method: RequestMethod,
    body: (any Encodable)? = nil,
    headers: [String: String]? = nil,
    dto: T.Type,
  ) -> String {

    let bodyAdjusted: String = {
      guard let bodyString = body as? String else {
        return "\(body ?? "nil")"
      }
      return bodyString.indentingEachLine(level: 1, indentString: "  | ")
    }()

    let headersAdjusted = headers?.displayString() ?? "nil"

    let result: String = """

      /// Request & Fetch ///

      DTO: \(dto)

      # Request
      URL: \(url?.absoluteString ?? "nil")
      Method: \(method)
      Body: \(bodyAdjusted)
      Headers: \(headersAdjusted)


      """

    return result

  }

  //  public static func encodeBody<T: Encodable>(_ body: T) -> Data? {
  //    do {
  //      let encoder = JSONEncoder()
  //      let jsonData = try encoder.encode(body)
  //      return jsonData
  //    } catch {
  //      print("Failed to encode request body: \(error)")
  //      return nil
  //    }
  //  }

}

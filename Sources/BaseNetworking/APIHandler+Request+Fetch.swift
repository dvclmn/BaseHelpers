//
//  File.swift
//
//
//  Created by Dave Coleman on 14/5/2024.
//

import Foundation
import BaseHelpers

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
      
      let bodyAdjusted: String = {
        if let bodyString = body as? String {
          let lines: [String.SubSequence] = bodyString.split(separator: "\n", omittingEmptySubsequences: true)
          
          let output: String = "\n  | " + lines.joined(separator: "\n  | ")
          return output
        } else {
          return "\(body ?? "nil")"
        }
      }()
      
      let headersAdjusted = headers?.displayString() ?? "nil"


      printPadded(
        """

        /// Request & Fetch ///

        DTO: \(dto)

        # Request
        URL: \(url?.absoluteString ?? "nil")
        Method: \(method)
        Body: \(bodyAdjusted)
        Headers: \(headersAdjusted)


        """)
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

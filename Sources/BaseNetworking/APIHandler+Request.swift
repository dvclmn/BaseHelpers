//
//  APIHandler+Request.swift
//  Collection
//
//  Created by Dave Coleman on 11/1/2025.
//

import BaseHelpers
import Foundation

extension APIHandler {

  public static func createRequest(
    url: URL?,
    method: RequestMethod = .get,
    body: (any Encodable)? = nil,
    headers: [String: String]? = nil
  ) throws -> URLRequest {

    guard let url else {
      throw APIError.badURL
    }

    var request = URLRequest(url: url)
    request.httpMethod = method.value

    /// Add headers
    if let headers {
      headers.forEach { key, value in
        request.setValue(value, forHTTPHeaderField: key)
      }
    }

    if let body {
      /// Printing body *before* it is encoded
      //      print("Request Body:\n\(body)")

      if let bodyString = body as? String {
        request.httpBody = bodyString.data(using: .utf8)
      } else {
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(body)
      }
    }

    return request
  }
}

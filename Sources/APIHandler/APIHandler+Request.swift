//
//  APIHandler+Request.swift
//  Collection
//
//  Created by Dave Coleman on 11/1/2025.
//

import Foundation

extension APIHandler {

  // Base request creator that other methods will use
  private static func baseRequest(
    url: URL?,
    type: APIRequestType,
    headers: [String: String]
  ) throws -> URLRequest {

    print("Putting together Base URLRequest")
    print("URL: \(url?.absoluteString ?? "nil")")

    guard let url else {
      throw APIError.badURL
    }

    var request = URLRequest(url: url)
    request.httpMethod = type.value

    // Add headers
    headers.forEach { key, value in
      request.setValue(value, forHTTPHeaderField: key)
    }

    return request
  }

  // GET request (or other methods without body)
  public static func createRequest(
    url: URL?,
    type: APIRequestType = .get,
    headers: [String: String] = [:]
  ) throws -> URLRequest {
    try baseRequest(
      url: url,
      type: type,
      headers: headers
    )
  }

  /// POST with `String` body
  public static func createRequest(
    url: URL?,
    body: String,
    headers: [String: String]
  ) throws -> URLRequest {
    var request = try baseRequest(
      url: url,
      type: .post,
      headers: headers
    )
    /// Printing body *before* it is encoded
    print("Request Body: \(body)")

    request.httpBody = body.data(using: .utf8)

    return request
  }

  /// POST with `Encodable` body
  public static func createRequest<T: Encodable>(
    url: URL?,
    body: T,
    headers: [String: String]
  ) throws -> URLRequest {
    var request = try baseRequest(
      url: url,
      type: .post,
      headers: headers
    )
    /// Printing body *before* it is encoded
    print("Request Body: \(body)")

    let encoder = JSONEncoder()
    request.httpBody = try encoder.encode(body)

    return request
  }

}

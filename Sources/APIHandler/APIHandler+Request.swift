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
    headers: [String: String],
    queryParameters: [String: String] = [:]
  ) throws -> URLRequest {
    // Start with the base URL
    guard var components = url.map({ URLComponents(url: $0, resolvingAgainstBaseURL: true) }) else {
      throw APIError.badURL
    }

    // Add query parameters if any
    components?.queryItems = queryParameters.map {
      URLQueryItem(name: $0.key, value: $0.value)
    }

    guard let finalURL = components?.url else {
      throw APIError.badURL
    }

    var request = URLRequest(url: finalURL)
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
    headers: [String: String] = [:],
    queryParameters: [String: String] = [:]
  ) throws -> URLRequest {
    try baseRequest(
      url: url,
      type: type,
      headers: headers,
      queryParameters: queryParameters
    )
  }

  // POST with String body
  public static func createRequest(
    url: URL?,
    body: String,
    headers: [String: String],
    queryParameters: [String: String] = [:]
  ) throws -> URLRequest {
    var request = try baseRequest(
      url: url,
      type: .post,
      headers: headers,
      queryParameters: queryParameters
    )

    request.httpBody = body.data(using: .utf8)
    print("Request Body: \(request.httpBody?.debugDescription ?? "")")

    return request
  }

  // POST with Encodable body
  public static func createRequest<T: Encodable>(
    url: URL?,
    body: T,
    headers: [String: String],
    queryParameters: [String: String] = [:]
  ) throws -> URLRequest {
    var request = try baseRequest(
      url: url,
      type: .post,
      headers: headers,
      queryParameters: queryParameters
    )

    let encoder = JSONEncoder()
    request.httpBody = try encoder.encode(body)
    print("Request Body: \(request.httpBody?.debugDescription ?? "")")

    return request
  }


  //  public static func createRequest(
  //    url: URL?,
  //    type: APIRequestType = .get,
  //    headers: [String : String] = [:]
  //  ) throws -> URLRequest {
  //
  //    guard let url = url else {
  //      print("Invalid URL")
  //      throw APIError.badURL
  //    }
  //    var request = URLRequest(url: url)
  //    request.httpMethod = type.value
  //
  //    for (key, value) in headers {
  //      request.setValue(value, forHTTPHeaderField: key)
  //    }
  //    return request
  //  }
  //
  //  public static func createRequest(
  //    url: URL?,
  //    body: String,
  //    headers: [String : String]
  //  ) throws -> URLRequest {
  //
  //    guard let url = url else {
  //      print("Invalid URL")
  //      throw APIError.badURL
  //    }
  //
  //    var request = URLRequest(url: url)
  //    request.httpMethod = "POST"
  //    request.httpBody = body.data(using: .utf8)
  //
  //    os_log("Request Body: \(request.httpBody?.debugDescription ?? "")")
  //
  //    for (key, value) in headers {
  //      request.setValue(value, forHTTPHeaderField: key)
  //    }
  //    return request
  //  }
  //
  //  public static func createRequest<T: Encodable>(
  //    url: URL?,
  //    body: T,
  //    headers: [String : String]
  //  ) throws -> URLRequest {
  //
  //    os_log("Let's make a URLRequest, with a body")
  //
  //    guard let url = url else {
  //      print("Invalid URL")
  //      throw APIError.badURL
  //    }
  //
  //    var request = URLRequest(url: url)
  //    request.httpMethod = "POST"
  //
  //    let encoder = JSONEncoder()
  //    let data = try encoder.encode(body)
  //    request.httpBody = data
  //
  //    os_log("Request Body: \(request.httpBody?.debugDescription ?? "")")
  //
  //    for (key, value) in headers {
  //      request.setValue(value, forHTTPHeaderField: key)
  //    }
  //    return request
  //  }
}

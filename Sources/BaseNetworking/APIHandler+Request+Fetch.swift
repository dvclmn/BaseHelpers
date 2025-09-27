//
//  File.swift
//
//
//  Created by Dave Coleman on 14/5/2024.
//

import BaseHelpers
import Foundation

public final class APIRequest<T: Decodable> {
  let url: URL?
  let method: RequestMethod
  let body: (any Encodable)?
  let headers: [String: String]?
  let dto: T.Type
  let isDebugMode: Bool

  public init(
    url: URL?,
    method: RequestMethod,
    body: (any Encodable)? = nil,
    headers: [String: String]? = nil,
    dto: T.Type,
    isDebugMode: Bool = false
  ) {
    self.url = url
    self.method = method
    self.body = body
    self.headers = headers
    self.dto = dto
    self.isDebugMode = isDebugMode
  }
}

extension APIRequest {
  public func requestAndFetch() async throws -> T {

    if isDebugMode { printPadded(displayString) }

    let request = try createRequest()
    let response: T = try await fetch(request: request)
    return response
  }
}

extension APIRequest {
  public var displayString: String {

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
}

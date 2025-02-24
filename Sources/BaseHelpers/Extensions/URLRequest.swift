//
//  URLRequest.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 24/2/2025.
//

import Foundation

//extension URLRequest {
//  public func prettyPrinted() -> String {
//
//    var requestComponents = [String: String?]()
//
//    if let url = self.url {
//      requestComponents["URL"] = url.absoluteString
//    }
//
//    if let method = self.httpMethod {
//      requestComponents["Method"] = method
//    }
//
//    if let headers = self.allHTTPHeaderFields {
//      requestComponents["Headers"] = headers
//    }
//
//    if let body = self.httpBody, let bodyString = String(data: body, encoding: .utf8) {
//      /// Attempt to serialize JSON body to a readable JSON String
//      if let jsonObject = try? JSONSerialization.jsonObject(with: body, options: []),
//        let prettyPrintedData = try? JSONSerialization.data(
//          withJSONObject: jsonObject, options: [.prettyPrinted]),
//        let prettyPrintedString = String(data: prettyPrintedData, encoding: .utf8)
//      {
//        requestComponents["Body"] = prettyPrintedString
//      } else {
//        /// If body is not JSON or not decodable, print as a string
//        requestComponents["Body"] = bodyString
//      }
//    }
//
//    guard
//      let jsonData = try? JSONSerialization.data(
//        withJSONObject: requestComponents, options: [.prettyPrinted]
//      ),
//      let jsonString = String(data: jsonData, encoding: .utf8)
//    else {
//      return "Didn't work"
//    }
//    return jsonString
//  }
//}

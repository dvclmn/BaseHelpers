//
//  Data.swift
//  Collection
//
//  Created by Dave Coleman on 19/1/2025.
//

import Foundation

extension Data {
  /// NSString gives us a nice sanitized debugDescription
  /// https://gist.github.com/cprovatas/5c9f51813bc784ef1d7fcbfb89de74fe
  public var prettyPrintedJSONString: NSString? {
    guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
      let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
      let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
    else { return nil }

    return prettyPrintedString
  }

  public var debugString: String {
    if let jsonString = String(data: self, encoding: .utf8) {
      /// Attempt to pretty-print if it's JSON
      if let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []),
        let prettyData = try? JSONSerialization.data(
          withJSONObject: jsonObject,
          options: [.prettyPrinted, .sortedKeys]
        ),
        let prettyString = String(data: prettyData, encoding: .utf8)
      {
        return prettyString
      }
      /// Fallback to raw string if not JSON
      return jsonString
    }
    return "Unable to decode data as UTF-8 string."
  }
}

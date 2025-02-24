//
//  Encodable.swift
//  Collection
//
//  Created by Dave Coleman on 19/1/2025.
//

import Foundation

extension Encodable {
  public var prettyPrintedJSONString: String {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    guard let data = try? encoder.encode(self) else { return "nil" }
    return String(data: data, encoding: .utf8) ?? "nil"
  }
}

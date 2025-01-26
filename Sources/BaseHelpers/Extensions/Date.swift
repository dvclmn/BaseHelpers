//
//  Date.swift
//  Collection
//
//  Created by Dave Coleman on 22/1/2025.
//

import Foundation

extension Date: @retroactive RawRepresentable {
  public var rawValue: String {
    self.timeIntervalSinceReferenceDate.description
  }

  public init?(rawValue: String) {
    self = Date(timeIntervalSinceReferenceDate: Double(rawValue) ?? 0.0)
  }
}

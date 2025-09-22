//
//  OptionSet.swift
//  Collection
//
//  Created by Dave Coleman on 30/10/2024.
//

import SwiftUI

/// https://gist.github.com/shaps80/5615c8a71fe26d229bf063d2e7c87a5c

public extension Binding where Value: OptionSet & Sendable, Value.Element: Sendable {
  func toggling(_ value: Value.Element) -> Binding<Bool> {
    .init(
      get: {
        wrappedValue.contains(value)
      },
      set: {
        if $0 {
          wrappedValue.insert(value)
        } else {
          wrappedValue.remove(value)
        }
      }
    )
  }
}

//extension OptionSet where Self: CustomStringConvertible {
//  static func describe(_ mapping: [(Self, String)], for value: Self) -> String {
//    let names = mapping.compactMap { value.contains($0.0) ? $0.1 : nil }
//    return "\(Self.self)(\(names.joined(separator: ", ")))"
//  }
//}

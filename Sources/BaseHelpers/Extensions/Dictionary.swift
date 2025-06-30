//
//  Dictionary.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 30/6/2025.
//

import Foundation

extension Dictionary {
  public func sorted<T: Comparable>(
    by keyPath: KeyPath<Element, T>,
    using comparator: (T, T) -> Bool = (<)
  ) -> [Element] {
    sorted { a, b in
      comparator(a[keyPath: keyPath], b[keyPath: keyPath])
    }
  }
}

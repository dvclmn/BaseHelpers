//
//  Dictionary.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 30/6/2025.
//

import Foundation

extension Dictionary {
  /// Non-native key path based sorting for Dictionary
  public func sorted<T: Comparable>(
    byKeyPath keyPath: KeyPath<Element, T>,
    using comparator: (T, T) -> Bool = (<)
  ) -> [Element] {
    sorted { a, b in
      comparator(a[keyPath: keyPath], b[keyPath: keyPath])
    }
  }

  /// Allows use of a `KeyPath` for grouping, like
  /// ```
  /// var groupedDictionary: [String: [Swatch]] {
  ///   Dictionary(
  ///     grouping: Swatch.allCases,
  ///     by: keyPath
  ///   )
  /// }
  /// ```
  public init<S: Sequence>(
    grouping values: S,
    by keyPath: KeyPath<S.Element, Key>
  ) where Value == [S.Element] {
    self.init(grouping: values, by: { $0[keyPath: keyPath] })
  }

}

extension Dictionary where Value: Sequence {
  /// Flattens all values and sorts the resulting elements by the given key path.
  public func sortedGrouped<T: Comparable>(
    by keyPath: KeyPath<Value.Element, T>
  ) -> [Value.Element] {
    self.flatMap(\.value).sorted(byKeyPath: keyPath)
  }
}

extension Dictionary where Value == Bool {
  /// Toggles the value for the given key.
  /// If the key does not exist, it's assumed to be `false` and set to `true`.
  @discardableResult
  public mutating func toggleValue(
    forKey key: Key,
    fallBack: Bool = false
  ) -> Bool {
    let newValue = !(self[key] ?? fallBack)
    self[key] = newValue
    return newValue
    //    self[key] = !(self[key] ?? fallBack)
  }
}

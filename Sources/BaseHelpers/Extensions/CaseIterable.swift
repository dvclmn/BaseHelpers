//
//  CaseIterable.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 27/8/2025.
//

import Foundation

extension CaseIterable where Self: Hashable {
  /// Creates a dictionary containing all cases as keys with the same default value.
  public static func casesDictionary<T>(defaultValue: T) -> [Self: T] {
    Dictionary(uniqueKeysWithValues: allCases.map { ($0, defaultValue) })
  }
}

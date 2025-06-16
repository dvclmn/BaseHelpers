//
//  AllCases.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 16/6/2025.
//

import Foundation

extension Collection where Element: CaseIterable, Element == Self.Element.AllCases {
  public var toArray: [Element] {
    return Array(self)
  }
}

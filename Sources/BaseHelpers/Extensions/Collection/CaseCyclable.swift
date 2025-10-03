//
//  CaseCyclable.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 31/8/2025.
//

import Foundation

public protocol CaseCyclable: CaseIterable, LabeledItem
where
  AllCases: RandomAccessCollection,
  AllCases.Index == Int
{
  static var defaultCase: Self { get }
}

extension CaseCyclable {
  public var isAtBeginning: Bool { self == Self.allCases.first }
  public var isAtEnd: Bool { self == Self.allCases.last }

  public func toNext(wrapping: Bool = true) -> Self {
    Self.allCases.nextElement(after: self, wrapping: wrapping) ?? Self.defaultCase
  }

  public func toPrevious(wrapping: Bool = true) -> Self {
    Self.allCases.previousElement(before: self, wrapping: wrapping) ?? Self.defaultCase
  }

  public mutating func moveForward(wrapping: Bool = true) {
    self = toNext(wrapping: wrapping)
  }
  public mutating func moveBackward(wrapping: Bool = true) {
    self = toPrevious(wrapping: wrapping)
  }
}


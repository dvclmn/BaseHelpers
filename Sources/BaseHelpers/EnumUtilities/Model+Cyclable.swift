//
//  Cyclable.swift
//  BaseComponents
//
//  Created by Dave Coleman on 14/5/2025.
//

import Foundation

public protocol Cyclable: LabeledEnum
where Self.AllCases.Index == Int {

  static var defaultCase: Self { get }
}



public enum MoveDirection {
  case next
  case previous
}


extension Cyclable {
  
  public var isAtBeginning: Bool {
    return self == Self.allCases.first
  }
  public var isAtEnd: Bool {
    return self == Self.allCases.last
  }

  public func toNext(wrapping: Bool = true) -> Self {
    let allCases = Self.allCases
    guard let currentIndex: Int = allCases.firstIndex(of: self) else {
      return Self.defaultCase
    }
    let nextIndex: Int = allCases.nextIndexClamped(after: currentIndex, wrapping: wrapping)
    return allCases[nextIndex]
  }
  
  public func toPrevious(wrapping: Bool = true) -> Self {
    let allCases = Self.allCases
    guard let currentIndex: Int = allCases.firstIndex(of: self) else {
      return Self.defaultCase
    }
    let prevIndex: Int = allCases.previousIndexClamped(before: currentIndex, wrapping: wrapping)
    return allCases[prevIndex]
  }

  /// Useful for in-place mutation, allow more concise usage, e.g.:
  /// `modeHandler.currentMode.cycleForward()`
  public mutating func moveForward(wrapping: Bool = true) {
    self = toNext(wrapping: wrapping)
  }

  public mutating func moveBackward(wrapping: Bool = true) {
    self = toPrevious(wrapping: wrapping)
  }

  /// A toggle method, only available for two-case enums
  public mutating func toggle() {
    precondition(Self.allCases.count == 2, "toggle() is only valid for two-case enums")
    self = toNext(wrapping: true)
  }
}

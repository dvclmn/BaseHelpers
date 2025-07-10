//
//  Model+DisplayPair.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 10/7/2025.
//

import Foundation

/// A good example is `CGPoint`:
/// ```
/// valueA = self.x
/// valueB = self.y
/// valueALabel = "X"
/// valueBLabel = "Y"
/// ```
public protocol DisplayPair {
  associatedtype Value: SingleValueStringable
  var valueA: Value { get }
  var valueB: Value { get }
  var valueALabel: String { get }
  var valueBLabel: String { get }
  
  var displayString: String { get }
  var displayStringStyled: AttributedString { get }
}

extension DisplayPair  {
  
  public var displayString: String {
    return displayStringStyled.toString
  }
  
  public var displayStringStyled: AttributedString {
    let result = valuePair(self)
    return result
  }
}

//public protocol ValuePair {
//  associatedtype Value
//  var valueA: Value { get }
//  var valueB: Value { get }
//}

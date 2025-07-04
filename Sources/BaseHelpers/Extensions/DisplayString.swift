//
//  DisplayString.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/7/2025.
//

import SwiftUI

/// I think I can just express the other shapes, directly.
/// E.g. single float values like `CGFloat` using `BinaryFloatingPoint`,
/// `CGRect`, who has four values to display, etc.
public protocol ValuePair {
  var valueA: Double { get }
  var valueB: Double { get }
  
  var displayString: String { get }
  func displayString(
    _ decimalPlaces: Int,
    grouping: Decimal.FormatStyle.Configuration.Grouping
  ) -> String
}

extension CGPoint: ValuePair {
  public var valueA: Double { x }
  public var valueB: Double { y }
}
extension CGSize: ValuePair {
  public var valueA: Double { width }
  public var valueB: Double { height }
}
extension CGVector: ValuePair {
  public var valueA: Double { dx }
  public var valueB: Double { dy }
}
extension UnitPoint: ValuePair {
  public var valueA: Double { x }
  public var valueB: Double { y }
}

public protocol SingleValue {
  func displayString(
    _ decimalPlaces: Int,
    grouping: Decimal.FormatStyle.Configuration.Grouping
  ) -> String
}

extension ValuePair {
  
  public var displayString: String { self.displayString() }
  public func displayString(
    _ decimalPlaces: Int = 2,
    grouping: Decimal.FormatStyle.Configuration.Grouping = .automatic
  ) -> String {
    
    let formattedA: String = valueA.formatted(.number.precision(.fractionLength(decimalPlaces)).grouping(grouping))
    let formattedB: String = valueA.formatted(.number.precision(.fractionLength(decimalPlaces)).grouping(grouping))
    return String(formattedA + " x " + formattedB)
  }
}

//
//  DisplayString.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/7/2025.
//

import SwiftUI

public enum ValueDisplayStyle {
  case labels
  case plain
  
  public var isShowingLabels: Bool { self == .labels }
}

/// I think I can just express the other shapes, directly.
/// E.g. single float values like `CGFloat` using `BinaryFloatingPoint`,
/// `CGRect`, who has four values to display, etc.
public protocol ValuePair {
  var valueA: Double { get }
  var valueB: Double { get }

  var valueALabel: String { get }
  var valueBLabel: String { get }

  var displayString: String { get }
  func displayString(
    _ decimalPlaces: Int,
    style: ValueDisplayStyle,
    hasSpace: Bool,
    grouping: Decimal.FormatStyle.Configuration.Grouping
  ) -> String
}

extension CGPoint: ValuePair {
  public var valueA: Double { x }
  public var valueB: Double { y }
  public var valueALabel: String { "X" }
  public var valueBLabel: String { "Y" }
}
extension CGSize: ValuePair {
  public var valueA: Double { width }
  public var valueB: Double { height }
  public var valueALabel: String { "W" }
  public var valueBLabel: String { "H" }
}
extension CGVector: ValuePair {
  public var valueA: Double { dx }
  public var valueB: Double { dy }
  public var valueALabel: String { "DX" }
  public var valueBLabel: String { "DY" }
}
extension UnitPoint: ValuePair {
  public var valueA: Double { x }
  public var valueB: Double { y }
  public var valueALabel: String { "X" }
  public var valueBLabel: String { "Y" }
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
    style: ValueDisplayStyle = .labels,
    hasSpace: Bool = true,
    grouping: Decimal.FormatStyle.Configuration.Grouping = .automatic
  ) -> String {

    let formattedA: String = valueA.formatted(.number.precision(.fractionLength(decimalPlaces)).grouping(grouping))
    let formattedB: String = valueB.formatted(.number.precision(.fractionLength(decimalPlaces)).grouping(grouping))
    
    let spaceIfNeeded: String = hasSpace ? " " : ""
    
    let formattedResult: String
    if style.isShowingLabels {
      formattedResult = String("\(self.valueALabel) \(formattedA),\(spaceIfNeeded)\(self.valueBLabel) \(formattedB)")
    } else {
      formattedResult = String("\(formattedA),\(spaceIfNeeded)\(formattedB)")
    }
    return formattedResult
  }
}

//
//  DisplayString.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/7/2025.
//

import SwiftUI

public protocol ValuePair {
  var valueA: Double { get }
  var valueB: Double { get }
}
//public protocol ValueSingle{
//  var value: Double { get }
//}

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
//extension BinaryFloatingPoint {
//  public var value: Double { Double(self) }
//}

public protocol ValuePairStringable {
  associatedtype Value: ValuePair
  var value: Value { get }
  func displayString(
    _ decimalPlaces: Int,
    grouping: Decimal.FormatStyle.Configuration.Grouping
  ) -> String
}

public protocol SingleValueStringable {
  associatedtype Value: BinaryFloatingPoint
  var value: Value { get }
  func displayString(
    _ decimalPlaces: Int,
    grouping: Decimal.FormatStyle.Configuration.Grouping
  ) -> String
}

extension ValuePairStringable {
  public func displayString(
    _ decimalPlaces: Int = 2,
    grouping: Decimal.FormatStyle.Configuration.Grouping = .automatic
  ) -> String {
    
    let formattedA: String = value.valueA.formatted(.number.precision(.fractionLength(decimalPlaces)).grouping(grouping))
    let formattedB: String = value.valueA.formatted(.number.precision(.fractionLength(decimalPlaces)).grouping(grouping))
    return String(formattedA + " x " + formattedB)
  }
}
extension BinaryFloatingPoint {
  public func displayString(
    _ decimalPlaces: Int = 2,
    grouping: Decimal.FormatStyle.Configuration.Grouping = .automatic
  ) -> String {
    
    let formatted: String = Double(self).formatted(.number.precision(.fractionLength(decimalPlaces)).grouping(grouping))

    return String(formatted)
  }
}




//extension CGPoint: ValuePairable {
//  public var valueAPath: KeyPath<Self, CGFloat> { \.x }
//  public var valueBPath: KeyPath<Self, CGFloat> { \.y }
//}
//extension CGSize: ValuePairable {
//  public var valueAPath: KeyPath<Self, CGFloat> { \.width }
//  public var valueBPath: KeyPath<Self, CGFloat> { \.height }
//}
//extension CGVector: ValuePairable {
//  public var valueAPath: KeyPath<Self, CGFloat> { \.dx }
//  public var valueBPath: KeyPath<Self, CGFloat> { \.dy }
//}
//extension UnitPoint: ValuePairable {
//  public var valueAPath: KeyPath<Self, CGFloat> { \.x }
//  public var valueBPath: KeyPath<Self, CGFloat> { \.y }
//}
//
//public protocol ValuePairable {
//  associatedtype Root: ValuePairable
//  var valueAPath: KeyPath<Root, CGFloat> { get }
//  var valueBPath: KeyPath<Root, CGFloat> { get }
//}
//public protocol DisplayStringable {
//  associatedtype Value: ValuePairable
//  var value: Value { get }
//  var displayString: String { get }
//
//}
//extension DisplayStringable {
//  public var displayString: String {
//    self.displayString()
//  }
//
//  public func displayString(
//    _ decimalPlaces: Int = 2,
//    grouping: Decimal.FormatStyle.Configuration.Grouping = .automatic
//  ) -> String {
//
//    let formattedA: String = Double(self[keyPath: valueAPath]).formatted(
//      .number.precision(.fractionLength(decimalPlaces)).grouping(grouping))
//    let formattedB: String = Double(self.y).formatted(
//      .number.precision(.fractionLength(decimalPlaces)).grouping(grouping))
//    return String(formattedA + " x " + formattedB)
//  }
//}

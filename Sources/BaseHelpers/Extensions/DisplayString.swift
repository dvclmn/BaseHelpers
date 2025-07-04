//
//  DisplayString.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/7/2025.
//

import SwiftUI

public protocol ValuePairable {
  var valueA: CGFloat { get }
  var valueB: CGFloat { get }
}

extension CGPoint: ValuePairable {
  public var valueA: CGFloat { x }
  public var valueB: CGFloat { y }
}
extension CGSize: ValuePairable {
  public var valueA: CGFloat { width }
  public var valueB: CGFloat { height }
}
extension CGVector: ValuePairable {
  public var valueA: CGFloat { dx }
  public var valueB: CGFloat { dy }
}
extension UnitPoint: ValuePairable {
  public var valueA: CGFloat { x }
  public var valueB: CGFloat { y }
}

public protocol DisplayStringable {
  associatedtype Value: ValuePairable
  var value: Value { get }
  func displayString(
    _ decimalPlaces: Int,
    grouping: Decimal.FormatStyle.Configuration.Grouping
  ) -> String
}

extension DisplayStringable {
  public func displayString(
    _ decimalPlaces: Int = 2,
    grouping: Decimal.FormatStyle.Configuration.Grouping = .automatic
  ) -> String {
    
    
    let formattedDX: String = Double(self.dx).formatted(.number.precision(.fractionLength(decimalPlaces)).grouping(grouping))
    let formattedDY: String = Double(self.dy).formatted(.number.precision(.fractionLength(decimalPlaces)).grouping(grouping))
    return String(formattedDX + " x " + formattedDY)
    
//    let numberFormatter = NumberFormatter()
//    numberFormatter.minimumFractionDigits = decimalPlaces
//    numberFormatter.maximumFractionDigits = decimalPlaces
//    numberFormatter.usesGroupingSeparator = (grouping != .never)
//    
//    let formatStyle = FloatingPointFormatStyle<Double>()
//      .precision(.fractionLength(decimalPlaces))
//      .grouping(grouping)
//    
//    let formattedA = Double(value.valueA).formatted(formatStyle)
//    let formattedB = Double(value.valueB).formatted(formatStyle)
    
    return "\(formattedA) × \(formattedB)"
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

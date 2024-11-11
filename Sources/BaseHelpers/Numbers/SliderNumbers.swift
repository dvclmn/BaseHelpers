//
//  Numbers.swift
//  Collection
//
//  Created by Dave Coleman on 8/11/2024.
//

import Foundation

/// Protocol to unify numeric types
public protocol SliderValue: Comparable {
  var asDouble: Double { get }
  init(_ double: Double)
  static func convert<T: BinaryFloatingPoint>(_ value: T) -> Self
  static prefix func -(operand: Self) -> Self  // Negation requirement
}

/// Conform floating point types
extension BinaryFloatingPoint where Self: SliderValue {
  public var asDouble: Double { Double(self) }
  public static func convert<T: BinaryFloatingPoint>(_ value: T) -> Self {
    Self(Double(value))
  }
}

/// Conform integer types
extension BinaryInteger where Self: SliderValue {
  public var asDouble: Double { Double(self) }
  public static func convert<T: BinaryFloatingPoint>(_ value: T) -> Self {
    Self(Double(value))
  }
}

/// Add conformance for common types
extension Int: SliderValue {}
extension Double: SliderValue {}
extension Float: SliderValue {}
extension CGFloat: SliderValue {}



public extension ClosedRange where Bound == Int {
  var doubleRange: ClosedRange<Double> {
    self.lowerBound.asDouble...self.upperBound.asDouble
  }
}

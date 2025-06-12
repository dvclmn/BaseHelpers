//
//  DisplayString.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 12/6/2025.
//

import Foundation


/// Aiming to support:
///
/// - CGFloat/Double
/// - CGPoint (x and y)
/// - CGSize (width and height)
/// - CGRect (origin and size)
/// - CGVector
/// etc

// Base unit types
public protocol UnitType {
  var stringRepresentation: String { get }
  var shortForm: String { get }
}

// Specific unit categories
public protocol CoordinateUnit: UnitType {
  
}
public protocol DimensionUnit: UnitType {}
public protocol DeltaUnit: UnitType {}

/// This can be either
/// a) A final, singular Float value, like CGFloat/Double
/// b) Or a yet-to-decompose ValuePair
public protocol DisplayValue {
  /// How to write this, if it can be either one of a single, or double?
  /// What's the min requirement?
  func displayString(decimalPlaces: Int, style: DisplayStringStyle) -> String
}

public protocol ValueSingle: DisplayValue {
  associatedtype FloatType: BinaryFloatingPoint
  var value: FloatType { get }
}


/// This is meant to express that Value 01 and 02
/// may not neccesarily be full resolved yet, to a Float
/// An example being `CGrect`; whilst it does have
/// 2 values (when expressed a origin and size), both
/// origin and size can *further* be resolved, down to
/// x/y and width/height.
public protocol ValuePair: DisplayValue {
  associatedtype FirstValue: DisplayValue
  associatedtype SecondValue: DisplayValue
  associatedtype FirstUnit: UnitType
  associatedtype SecondUnit: UnitType
  
  var firstValue: FirstValue { get }
  var secondValue: SecondValue { get }
  var firstUnit: FirstUnit { get }
  var secondUnit: SecondUnit { get }
}



//public struct DisplayString<Value: DisplayValue> {
//  public let value: Value
//  public let decimalPlaces: Int
//  public let style: DisplayStringStyle
//  
//  public init(
//    value: Value,
//    decimalPlaces: Int = 2,
//    style: DisplayStringStyle = .standard
//  ) {
//    self.value = value
//    self.decimalPlaces = decimalPlaces
//    self.style = style
//  }
//}
//
//extension DisplayString {
//  
//}
//

public enum DisplayStringStyle {
  case short
  case standard
  case long
}

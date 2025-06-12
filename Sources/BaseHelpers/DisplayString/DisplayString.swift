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

/// This can be either
/// a) A final, singular Float value, like CGFloat/Double
/// b) Or a yet-to-decompose ValuePair
public protocol DisplayValue {
  /// How to write this, if it can be either one of a single, or double?
  /// What's the min requirement?
  func displayString(decimalPlaces: Int, style: DisplayStringStyle) -> String
}

public protocol ValueSingle: DisplayValue {
  associatedtype Value: BinaryFloatingPoint
  var value: Value { get }
}

/// This is meant to express that Value 01 and 02
/// may not neccesarily be full resolved yet, to a Float
/// An example being `CGrect`; whilst it does have
/// 2 values (when expressed a origin and size), both
/// origin and size can *further* be resolved, down to
/// x/y and width/height.
public protocol ValuePair: DisplayValue {
  associatedtype Value: DisplayValue
  var value01: Value { get }
  var value02: Value { get }
}

public struct PointDisplayString: ValuePair {
  public typealias Value = CGPoint
  public var value01: Value
  public var value02: Value
  
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
//public enum DisplayStringStyle {
//  case short
//  case standard
//  case long
//}

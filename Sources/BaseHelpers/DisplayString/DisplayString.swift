//
//  DisplayString.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 12/6/2025.
//

/// Aiming to support:
///
/// - CGFloat/Double
/// - CGPoint (x and y)
/// - CGSize (width and height)
/// - CGRect (origin and size)
/// - CGVector
/// etc
public struct DisplayString<Value: BinaryFloatingPoint> {
  public let value: Value
  public let decimalPlaces: Int
  public let style: DisplayStringStyle
  
  public init(
    value: Value,
    decimalPlaces: Int = 2,
    style: DisplayStringStyle = .standard
  ) {
    self.value = value
    self.decimalPlaces = decimalPlaces
    self.style = style
  }
}

extension DisplayString {
  
}

public enum DisplayStringStyle {
  case short
  case standard
  case long
}

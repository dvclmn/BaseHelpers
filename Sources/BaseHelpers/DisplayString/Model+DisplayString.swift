//
//  DisplayString.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 12/6/2025.
//

import Foundation

public enum DisplayStringStyle {
  case short
  case standard
  case long
}




/// Aiming to support:
///
/// - CGFloat/Double
/// - CGPoint (x and y)
/// - CGSize (width and height)
/// - CGRect (origin and size)
/// - CGVector
/// etc

//public enum ColumnWidth {
//  case integer(Int)
//  case decimal(Int)
//}

//public enum PaddingStragey {
//  case padLeading(Character = "")
//  case noPadding
//}

/// This can be either
/// a) A final, singular Float value, like CGFloat/Double
/// b) Or a yet-to-decompose ValuePair
//public protocol DisplayValue {
//
//  func displayString(
//    integerWidth: Int?, // nil == unlimited
//    decimalPlaces: Int,
//    paddingCharacter: Character?, // nil == no padding
//    style: DisplayStringStyle
//  ) -> String
//
//}
//
//public protocol ValueSingle {
//  associatedtype FloatType: BinaryFloatingPoint
////  var value: FloatType { get }
//}
//
//
//public enum DecimalPlace {
//  case integer(targetWidth: Int)
//  case decimal(places: Int)
//}
//
///// This is meant to express that Value 01 and 02
///// may not neccesarily be full resolved yet, to a Float
///// An example being `CGrect`; whilst it does have
///// 2 values (when expressed a origin and size), both
///// origin and size can *further* be resolved, down to
///// x/y and width/height.
//public protocol ValuePair {
//  associatedtype FirstValue: BinaryFloatingPoint
//  associatedtype SecondValue: BinaryFloatingPoint
//  
//  var firstValue: FirstValue { get }
//  var secondValue: SecondValue { get }
//}

//public protocol ValueSingle {
//  associatedtype FloatType: BinaryFloatingPoint
//  //  var value: FloatType { get }
//}
//
//public struct ValuePair<First: BinaryFloatingPoint, Second: BinaryFloatingPoint> {
////  associatedtype FirstValue: BinaryFloatingPoint
////  associatedtype SecondValue: BinaryFloatingPoint
//  let firstValue: First
//  let secondValue: Second
//  
//}


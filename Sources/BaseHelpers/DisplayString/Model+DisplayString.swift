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
public protocol DisplayValue {

  func displayString(
    integerWidth: Int?, // nil == unlimited
    decimalPlaces: Int,
    paddingStrategy: PaddingStragey,
    style: DisplayStringStyle
  ) -> String

}

public protocol ValueSingle: DisplayValue {
  associatedtype FloatType: BinaryFloatingPoint
  var value: FloatType { get }
}


public enum DecimalPlace {
  case integer(targetWidth: Int)
  case decimal(places: Int)
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
  
  var firstValue: FirstValue { get }
  var secondValue: SecondValue { get }
}

public enum DisplayStringStyle {
  case short
  case standard
  case long
}



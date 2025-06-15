//
//  ColumnConfiguration.swift
//  Components
//
//  Created by Dave Coleman on 20/12/2024.
//

//import MemberwiseInit
//import SwiftUI

/// This article outlines native Swift stuff that I should almost
/// *definitely* use, in place of this general setup here.
/// Or at least lean better into native types, than this.
/// https://swiftwithmajid.com/2023/07/04/mastering-swift-foundation-formatter-api-custom-format-styles/

//public struct ValueConfiguration: Equatable, Sendable {
//  public var integerDigits: Int
//  public var fractionalDigits: Int
//  public var usesDigitGrouping: Bool
//  public var includePolaritySign: Bool
//  
//  public init(
//    integerDigits: Int = 1,
//    fractionalDigits: Int = 2,
//    usesDigitGrouping: Bool = false,
//    includePolaritySign: Bool = false
//  ) {
//    self.integerDigits = integerDigits
//    self.fractionalDigits = fractionalDigits
//    self.usesDigitGrouping = usesDigitGrouping
//    self.includePolaritySign = includePolaritySign
//  }
//  
//  public static var float: Self {
//    Self(
//      integerDigits: 1,
//      fractionalDigits: 2
//    )
//  }
//  
//  public static var wholeNumber: Self {
//    Self(
//      integerDigits: 1,
//      fractionalDigits: 0
//    )
//  }
//  
//  public static var precise: Self {
//    Self(
//      integerDigits: 1,
//      fractionalDigits: 4
//    )
//  }
//}
//
//extension ValueModel {
//  
//  // MARK: - Configuration
//  
//  
//
////  public struct Configuration: Equatable, Sendable {
////
////    public var integerDigits: Int
////    public var fractionalDigits: Int
////    public var usesDigitGrouping: Bool
////    public var includePolaritySign: Bool
////
////    public init(
////      integerDigits: Int,
////      fractionalDigits: Int,
////      usesDigitGrouping: Bool = false,
////      includePolaritySign: Bool = false
////    ) {
////      self.integerDigits = integerDigits
////      self.fractionalDigits = fractionalDigits
////      self.usesDigitGrouping = usesDigitGrouping
////      self.includePolaritySign = includePolaritySign
////    }
////  }
//}
//
//extension ValueConfiguration {
//
////  public static var float: ValueDisplay.Configuration {
////    ValueDisplay.Configuration(
////      integerDigits: 2,
////      fractionalDigits: 2
////    )
////  }
////  
////  public static var wholeNumber: ValueDisplay.Configuration {
////    ValueDisplay.Configuration(
////      integerDigits: 3,
////      fractionalDigits: 0
////    )
////  }
//
//}
//
//extension ValueConfiguration: CustomStringConvertible {
//  public var description: String {
//    """
//
//    Column Config
//    -------------
//
//    Reservation:
//    Integer Digits: \(integerDigits)
//    Fractional Digits: \(fractionalDigits)
//    Uses Digit Grouping: \(usesDigitGrouping)
//    Include Polarity Sign?: \(includePolaritySign)
//
//    -------------
//
//    """
//  }
//}

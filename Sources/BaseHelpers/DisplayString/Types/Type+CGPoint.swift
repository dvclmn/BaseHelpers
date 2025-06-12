//
//  Type+CGPoint.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 12/6/2025.
//

import Foundation

//private func singleValueString()

//extension CGPoint: ValuePair {
//  public typealias FirstValue = CGFloat
//  public typealias SecondValue = CGFloat
//
//  public var firstValue: FirstValue { self.x }
//  public var secondValue: SecondValue { self.y }
//
//  public func displayString(
//    integerWidth: Int?,
//    decimalPlaces: Int,
//    paddingCharacter: Character?,
//    style: DisplayStringStyle
//      //      decimalPlaces: Int = 2,
//      //      style: DisplayStringStyle = .short
//  ) -> String {
//    
//    
//
//    // MARK: - First value
//    /// Integer column
//    
//    let firstValueString: String
//    
//    guard let integerWidth else {
//      firstValueString = "\(firstValue)"
//    }
//    
//    guard let paddingCharacter else {
//      firstValueString = ""
//    }
//    let firstValueIntegerPadding = DigitPadding(
//      Int(firstValue),
//      targetWidth: integerWidth,
//      paddingCharacter: paddingCharacter
//    )
//    firstValueString = firstValueIntegerPadding.paddedString()
//
//    
//    
//    
//    
//    let firstString: String = "\(self.x.displayString(decimalPlaces))"
//    let secondString: String = "\(self.y.displayString(decimalPlaces))"
//
//    switch style {
//      case .short:
//        return "\(width) x \(height)"
//
//      case .standard, .long:
//        return "X \(width)  Y \(height)"
//
//    }
//  }
//  //  public func displayString(
//  //    decimalPlaces: Int = 2,
//  //    style: DisplayStringStyle = .short
//  //  ) -> String {
//  //
//  //    let width: String = "\(self.x.displayString(decimalPlaces))"
//  //    let height: String = "\(self.y.displayString(decimalPlaces))"
//  //
//  //    switch style {
//  //      case .short:
//  //        return "\(width) x \(height)"
//  //
//  //      case .standard, .long:
//  //        return "X \(width)  Y \(height)"
//  //
//  //    }
//  //  }
//  
//  func firstValueIntegerColumn(
//    integerWidth: Int?,
//    paddingCharacter: Character?,
//  ) -> String {
//    
//    /// If integer has no width, then it's unlimited AND thus also doesn't need padding
//    guard let integerWidth else {
//      return "\(firstValue)"
//    }
//    
//    
//    
//    
//    if let paddingCharacter {
//      
//      
//      
//      firstValueString = ""
//      
//      
//    }
//    let firstValueIntegerPadding = DigitPadding(
//      Int(firstValue),
//      targetWidth: integerWidth,
//      paddingCharacter: paddingCharacter
//    )
//    firstValueString = firstValueIntegerPadding.paddedString()
//
//    return "\(firstValue)"
//  }
//}
//

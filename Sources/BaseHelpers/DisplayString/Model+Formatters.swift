//
//  Model+Formatters.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 10/7/2025.
//

import Foundation

struct FloatPairFormatter {
  let pair: any FloatPair
  let config: DisplayStringConfig
  
  init(
    pair: any FloatPair,
    config: DisplayStringConfig
  ) {
    self.pair = pair
    self.config = config
  }
}


extension FloatPairFormatter {
  var displayString: String {
    
    let formatter = SingleValueFormatter(config: config)
    
    let formattedA: String = formatter.displayString(pair.valueA, valueLabel: pair.valueALabel)
    let formattedB: String = formatter.displayString(pair.valueB, valueLabel: pair.valueBLabel)
    
    let spaceIfNeeded: String = config.hasSpaceBetweenValues ? " " : ""
    
    let formattedResult = String("\(formattedA),\(spaceIfNeeded)\(formattedB)")
    return formattedResult
  }
}

//struct SingleValueFormatter<Value: SingleValueStringable> {
//  let value: any SingleValueStringable
//  let config: DisplayStringConfig
//  
//  init(
//    config: DisplayStringConfig
//  ) {
//    self.config = config
//  }
//  
//  func displayString(_ value: Double, valueLabel: String) -> String {
//    
//    let formatted: String = value.formatted(
//      //      .number.precision(
//      //        .integerAndFractionLength(
//      //          integer: config.integerPlaces,
//      //          fraction: config.decimalPlaces
//      //        )
//      //      ).grouping(config.grouping)
//      .number.precision(
//        .fractionLength(
//          config.decimalPlaces
//        )
//      ).grouping(config.grouping)
//    )
//    return formatted
//    
//  }
//  
//}

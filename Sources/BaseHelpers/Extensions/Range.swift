//
//  Range.swift
//  Collection
//
//  Created by Dave Coleman on 22/12/2024.
//

import Foundation

public extension ClosedRange where Bound == CGFloat {
  var toDoubleRange: ClosedRange<Double> {
    return Double(self.lowerBound)...Double(self.upperBound)
  }
}

public extension NSRange {
  var info: String {
    return "NSRange(location: \(location), length: \(length))"
  }
  
  
  
  /// This is already present in Rearrange
  //  func clamped(to maxLength: Int) -> NSRange {
  //    let safeLocation = min(location, maxLength)
  //    let availableLength = maxLength - safeLocation
  //    let safeLength = min(length, availableLength)
  //
  //    return NSRange(location: safeLocation, length: safeLength)
  //  }
}


extension Range where Bound == String.Index {
  public func toNSRange(in string: String) -> NSRange {
    return string.nsRange(from: self)
  }
}

//
//  Range.swift
//  Collection
//
//  Created by Dave Coleman on 22/12/2024.
//

import Foundation

extension ClosedRange where Bound == CGFloat {
  public var toDoubleRange: ClosedRange<Double> {
    Double(self.lowerBound) ... Double(self.upperBound)
  }
}

extension NSRange {
  public var info: String {
    "NSRange(location: \(location), length: \(length))"
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

extension NSRange {
  public var debugDescription: String {
    "NSRange(location: \(location), length: \(length))"
  }
}


extension Range where Bound == String.Index {
  public func toNSRange(in string: String) -> NSRange {
    string.nsRange(from: self)
  }
}

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
extension ClosedRange where Bound == Double {
  public var toCGFloatRange: ClosedRange<CGFloat> {
    CGFloat(self.lowerBound) ... CGFloat(self.upperBound)
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

  public func getAttributedRange(in attrString: AttributedString) -> Range<AttributedString.Index>?
  {

    /// Convert String.Index range to AttributedString.Index range
    ///
    let startIndex = AttributedString.Index(self.lowerBound, within: attrString)
    let endIndex = AttributedString.Index(self.upperBound, within: attrString)

    /// Check if both indices are valid
    ///
    guard let start = startIndex, let end = endIndex else {
      print("Invalid range")
      return nil
    }

    /// Create the AttributedString range
    ///
    let attributedStringRange: Range<AttributedString.Index> = start ..< end

    return attributedStringRange
  }
}

//
//  Range+StringIndex.swift
//  TextCore
//
//  Created by Dave Coleman on 30/8/2024.
//

import Foundation


public extension Range where Bound == String.Index {
  
  func getAttributedRange(in attrString: AttributedString) -> Range<AttributedString.Index>? {
    
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
    let attributedStringRange: Range<AttributedString.Index> = start..<end
    
    return attributedStringRange
  }
}

//
//  File.swift
//  
//
//  Created by Dave Coleman on 10/8/2024.
//

import Foundation

extension String {
   func nsRange(from range: Range<String.Index>) -> NSRange {
      return NSRange(range, in: self)
   }
   
   func range(from nsRange: NSRange) -> Range<String.Index>? {
      return Range(nsRange, in: self)
   }
   
   func substring(with nsRange: NSRange) -> Substring? {
      guard let range = self.range(from: nsRange) else { return nil }
      return self[range]
   }
}

extension NSString {
   func range(from range: Range<String.Index>) -> NSRange {
      let utf16Start = range.lowerBound.utf16Offset(in: self as String)
      let utf16End = range.upperBound.utf16Offset(in: self as String)
      return NSRange(location: utf16Start, length: utf16End - utf16Start)
   }
}

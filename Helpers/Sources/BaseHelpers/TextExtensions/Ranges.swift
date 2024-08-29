//
//  File.swift
//  
//
//  Created by Dave Coleman on 10/8/2024.
//

import Foundation
import SwiftUI

// Credit: https://github.com/krzyzanowskim/STTextKitPlus/blob/main/Sources/STTextKitPlus/NSRange.swift

//extension Range where Bound == String.Index {
//  
//  /// Converts a `Range<String.Index>` to an `NSTextRange`
//  /// - Parameter string: The string that this range is associated with
//  /// - Returns: An equivalent `NSTextRange`
//  func toNSTextRange(in string: String) -> NSTextRange? {
//    guard let start = NSTextLocation(string.distance(from: string.startIndex, to: self.lowerBound)),
//          let end = NSTextLocation(string.distance(from: string.startIndex, to: self.upperBound)) else {
//      return nil
//    }
//    return NSTextRange(location: start, end: end)
//  }
//  
//  /// Creates a `Range<String.Index>` from an `NSTextRange`
//  /// - Parameters:
//  ///   - nsRange: The `NSTextRange` to convert
//  ///   - string: The string that this range is associated with
//  /// - Returns: An equivalent `Range<String.Index>`
//  static func fromNSTextRange(_ nsRange: NSTextRange, in string: String) -> Range<String.Index>? {
//    guard let startOffset = nsRange.location.rawValue,
//          let endOffset = nsRange.endLocation.rawValue,
//          let startIndex = string.index(string.startIndex, offsetBy: startOffset, limitedBy: string.endIndex),
//          let endIndex = string.index(string.startIndex, offsetBy: endOffset, limitedBy: string.endIndex) else {
//      return nil
//    }
//    return startIndex..<endIndex
//  }
//}


public extension NSRange {
  
  func range(in string: String) -> Range<String.Index>? {
    return Range<String.Index>(self, in: string)
  }
   
   /// A value indicating that a requested item couldn’t be found or doesn’t exist.
   static let notFound = NSRange(location: NSNotFound, length: 0)
   
   /// A Boolean value indicating whether the range is empty.
   ///
   /// Range is empty when its length is equal 0
   var isEmpty: Bool {
      length == 0
   }

   /// Creates a new value object containing the specified Foundation range structure.
   var nsValue: NSValue {
      return NSValue(range: self)
   }
  
  
  init(_ textRange: NSTextRange, in provider: NSTextElementProvider) {
    let docLocation = provider.documentRange.location
    
    let start = provider.offset?(from: docLocation, to: textRange.location) ?? NSNotFound
    if start == NSNotFound {
      self.init(location: start, length: 0)
      return
    }
    
    let end = provider.offset?(from: docLocation, to: textRange.endLocation) ?? NSNotFound
    if end == NSNotFound {
      self.init(location: NSNotFound, length: 0)
      return
    }
    
    self.init(start..<end)
  }
  
  
  init(_ textLocation: NSTextLocation, in textContentManager: NSTextContentManager) {
    let offset = textContentManager.offset(from: textContentManager.documentRange.location, to: textLocation)
    self.init(location: offset, length: 0)
  }
   
   func toRange(in string: String) -> Range<String.Index>? {
      return Range(self, in: string)
   }
}

extension Range where Bound == String.Index {
   func toNSRange(in string: String) -> NSRange {
      return string.nsRange(from: self)
   }
}


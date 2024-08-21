//
//  File.swift
//  
//
//  Created by Dave Coleman on 10/8/2024.
//

import Foundation
import SwiftUI

// Credit: https://github.com/krzyzanowskim/STTextKitPlus/blob/main/Sources/STTextKitPlus/NSRange.swift


public extension NSRange {
  
  func range(in string: String) -> Range<String.Index>? {
    return Range<String.Index>(self, in: string)
  }
   
   /// A value indicating that a requested item couldn’t be found or doesn’t exist.
   public static let notFound = NSRange(location: NSNotFound, length: 0)
   
   /// A Boolean value indicating whether the range is empty.
   ///
   /// Range is empty when its length is equal 0
   public var isEmpty: Bool {
      length == 0
   }

   /// Creates a new value object containing the specified Foundation range structure.
   public var nsValue: NSValue {
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


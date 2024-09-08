//
//  File.swift
//
//
//  Created by Dave Coleman on 10/8/2024.
//

import Foundation
import SwiftUI



public extension NSRange {
  
  func range(in string: String) -> Range<String.Index>? {
    return Range<String.Index>(self, in: string)
  }
  
  /// The below should already be represented in `Rearrange`
//
//  init(_ textRange: NSTextRange, in provider: NSTextElementProvider) {
//    let docLocation = provider.documentRange.location
//    
//    let start = provider.offset?(from: docLocation, to: textRange.location) ?? NSNotFound
//    if start == NSNotFound {
//      self.init(location: start, length: 0)
//      return
//    }
//    
//    let end = provider.offset?(from: docLocation, to: textRange.endLocation) ?? NSNotFound
//    if end == NSNotFound {
//      self.init(location: NSNotFound, length: 0)
//      return
//    }
//    
//    self.init(start..<end)
//  }
  
  func toRange(in string: String) -> Range<String.Index>? {
    return Range(self, in: string)
  }
}

extension Range where Bound == String.Index {
  func toNSRange(in string: String) -> NSRange {
    return string.nsRange(from: self)
  }
}


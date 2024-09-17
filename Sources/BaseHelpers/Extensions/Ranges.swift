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

  
  func toRange(in string: String) -> Range<String.Index>? {
    return Range(self, in: string)
  }
}

extension Range where Bound == String.Index {
  func toNSRange(in string: String) -> NSRange {
    return string.nsRange(from: self)
  }
}


//
//  File.swift
//  
//
//  Created by Dave Coleman on 10/8/2024.
//

import Foundation
import SwiftUI

public extension NSTextLocation {
   
   static func == (lhs: Self, rhs: Self) -> Bool {
      lhs.compare(rhs) == .orderedSame
   }
   
   static func != (lhs: Self, rhs: Self) -> Bool {
      lhs.compare(rhs) != .orderedSame
   }
   
   static func < (lhs: Self, rhs: Self) -> Bool {
      lhs.compare(rhs) == .orderedAscending
   }
   
   static func <= (lhs: Self, rhs: Self) -> Bool {
      lhs == rhs || lhs < rhs
   }
   
   static func > (lhs: Self, rhs: Self) -> Bool {
      lhs.compare(rhs) == .orderedDescending
   }
   
   static func >= (lhs: Self, rhs: Self) -> Bool {
      lhs == rhs || lhs > rhs
   }
   
   static func ~= (a: Self, b: Self) -> Bool {
      a == b
   }
}

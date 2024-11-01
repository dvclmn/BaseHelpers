//
//  Range.swift
//  TextCore
//
//  Created by Dave Coleman on 4/10/2024.
//

import Foundation

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

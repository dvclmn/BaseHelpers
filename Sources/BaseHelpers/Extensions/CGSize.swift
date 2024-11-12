//
//  CGSize.swift
//  Collection
//
//  Created by Dave Coleman on 12/11/2024.
//

import Foundation

public extension CGSize {
  /// Returns true if both width and height are greater than zero
  var isPositive: Bool {
    return width > 0 && height > 0
  }
  
  /// Returns true if either width or height is zero or negative
  var isZeroOrNegative: Bool {
    return !isPositive
  }
  
  /// Returns true if both width and height are greater than or equal to zero
  var isNonNegative: Bool {
    return width >= 0 && height >= 0
  }
  
  var centrePoint: CGPoint {
    return CGPoint(x: width / 2, y: height / 2)
  }
}

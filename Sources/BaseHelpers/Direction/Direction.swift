//
//  Direction.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 3/7/2025.
//

import SwiftUI

/// This type assumes a top-left origin
public enum Direction {
  case up
  case down
  case left
  case right
  
  /// +1 or -1 multiplier, for 1D movement
  public var scalar: Int {
    switch self {
      case .up, .left: return -1
      case .down, .right: return 1
    }
  }
  
  public var axis: Axis {
    switch self {
      case .up, .down: return .vertical
      case .left, .right: return .horizontal
    }
  }
  
  /// A generic method to mutate a scalar
  public func apply(to value: Int, by delta: Int = 1) -> Int {
    value + scalar * delta
  }
  
  /// A helper to apply direction to a tuple (for 2D scenarios)
  public func offset(x: Int, y: Int, by delta: Int = 1) -> (x: Int, y: Int) {
    switch self {
      case .up:    return (x, y - delta)
      case .down:  return (x, y + delta)
      case .left:  return (x - delta, y)
      case .right: return (x + delta, y)
    }
  }
}

//
//  BinaryFloatingPoint.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 27/2/2025.
//

extension BinaryFloatingPoint {
  public var string: String {
    String("\(self)")
  }

  public var bump: Self {
    let nextFib = self * 1.618
    /// Approximate next Fibonacci number
    return (self + nextFib) / 2 /// Midpoint between current and next
  }
  
  public var bumpDown: Self {
    let prevFib = self * 0.618
    /// Approximate previous Fibonacci number using the inverse of the golden ratio
    return (self + prevFib) / 2 /// Midpoint between current and previous
  }
  
  public var constrainedOpacity: Self {
    return min(1.0, max(0.0, self))
  }
  
}

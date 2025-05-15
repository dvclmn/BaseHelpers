//
//  CGVector.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 5/5/2025.
//

import Foundation

extension CGVector {
  
  public var displayString: String {
    self.displayString(style: .full)
  }
  
  public func displayString(decimalPlaces: Int = 2, style: DisplayStringStyle = .short) -> String {
    
    let dxString = "\(self.dx.displayString(decimalPlaces))"
    let dyString = "\(self.dy.displayString(decimalPlaces))"
    
    switch style {
      case .short:
        return "\(dxString) x \(dyString)"
        
      case .full, .initials:
        return "dx: \(dxString)  dy: \(dyString)"
        
    }
  }
  
  public static func between(
    _ from: CGPoint,
    _ to: CGPoint,
    dt: TimeInterval
  ) -> CGVector {
    guard dt > 0 else { return .zero }
    return CGVector(
      dx: (to.x - from.x) / dt,
      dy: (to.y - from.y) / dt
    )
  }
  
  /// Velocity vs. Speed
  ///
  /// Velocity is a vector (has direction and magnitude, e.g., `dx` and `dy` in 2D space).
  /// Speed is the scalar magnitude of velocity (how fast, regardless of direction).
  ///
  /// The below takes the Euclidean norm (or "length") of the velocity vector,
  /// which is mathematically defined as: `speed = √(dx² + dy²)`
  ///
  /// Example usage:
  /// ```
  /// let velocity = CGVector(dx: 3.0, dy: 4.0)
  /// print(velocity.speed) // 5.0 (classic 3-4-5 triangle)
  ///
  /// ```
  public var speed: CGFloat {
    return sqrt(dx * dx + dy * dy)
  }
}

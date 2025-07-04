//
//  CGVector.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 5/5/2025.
//

import Foundation

extension CGVector {
  
//  public var displayString: String {
//    self.displayString()
//  }
//  
//  public func displayString(
//    _ decimalPlaces: Int = 2,
//    grouping: Decimal.FormatStyle.Configuration.Grouping = .automatic
//  ) -> String {
//    
//    let formattedDX: String = Double(self.dx).formatted(.number.precision(.fractionLength(decimalPlaces)).grouping(grouping))
//    let formattedDY: String = Double(self.dy).formatted(.number.precision(.fractionLength(decimalPlaces)).grouping(grouping))
//    return String(formattedDX + " x " + formattedDY)
//  }

  /// Implements fundamental kinematic calculation (velocity = displacement/time)
//  public static func computeSimpleVelocity(
//    from pointA: any TimestampedPosition,
//    to pointB: any TimestampedPosition,
//    minTimeDelta: TimeInterval = 0.001,
//  ) -> CGVector {
//    let dt = pointB.timestamp - pointA.timestamp
//    guard dt >= minTimeDelta else { return .zero }
//
//    return CGVector(
//      dx: (pointB.position.x - pointA.position.x) / dt,
//      dy: (pointB.position.y - pointA.position.y) / dt
//    )
//  }
  
  
//  public static func computeWeightedVelocity(
//    from history: [T],
//    weights: [Double]
//  ) -> CGVector {
////  public static func computeWeightedVelocity(for touchId: Int) -> CGVector {
//    
//    guard let history = touchHistories[touchId],
//          /// Need at least 2 points to calculate a meaningful velocity
//          history.count >= 2
//    else {
//      return .zero
//    }
//    
//    /// For very short history, use simple calculation
//    if history.count == 2 {
//      return CGVector.computeSimpleVelocity(from: history[0], to: history[1])
//    }
//    
//    /// Weighted average of velocities between consecutive points
//    var weightedDx: Double = 0
//    var weightedDy: Double = 0
//    var totalWeight: Double = 0
//    
//    /// Calculate velocity between each consecutive pair
//    for i in 1..<history.count {
//      let velocity = CGVector.computeSimpleVelocity(
//        from: history[i - 1],
//        to: history[i]
//      )
//      //      let velocity = computeSimpleVelocity(from: history[i - 1], to: history[i])
//      
//      /// Use weight based on how recent this velocity sample is
//      /// More recent samples (higher index) get higher weight
//      let weightIndex = min(i - 1, velocityWeights.count - 1)
//      let weight = velocityWeights[weightIndex]
//      
//      weightedDx += velocity.dx * weight
//      weightedDy += velocity.dy * weight
//      totalWeight += weight
//    }
//    
//    guard totalWeight > 0 else { return .zero }
//    
//    let finalVelocity = CGVector(
//      dx: weightedDx / totalWeight,
//      dy: weightedDy / totalWeight
//    )
//    
//    /// Clamp to reasonable bounds to prevent outliers
//    return clampVelocity(finalVelocity)
//  }


  /// Performs vector magnitude limiting while preserving direction
  /// Could apply to:
  /// - Game movement systems (limiting player/NPC speeds)
  /// - Physics simulations (terminal velocity, speed limits)
  /// - Animation easing and smoothing
  /// - Signal processing (amplitude limiting)
  /// - Any system needing bounded vector magnitudes
  public func clampVelocity(
    maxVelocity: Double = 10.0
  ) -> CGVector {

    guard magnitude > maxVelocity else { return self }

    /// Scale down to max velocity while preserving direction
    let scale = maxVelocity / magnitude

    return CGVector(
      dx: self.dx * scale,
      dy: self.dy * scale
    )
  }

  public var magnitude: CGFloat {
    return sqrt(dx * dx + dy * dy)
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
  
  public func normalisedSpeed(
    maxSpeed: CGFloat = 1000.0
  ) -> CGFloat {
    return min(speed / maxSpeed, 1.0)
  }
}

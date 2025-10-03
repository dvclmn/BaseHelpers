//
//  VelocityCalculator.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 27/6/2025.
//

import Foundation

public protocol Timestamped {
  var timestamp: TimeInterval { get }
}

public protocol Positioned {
  var position: CGPoint { get }
}

public typealias TimestampedPosition = Timestamped & Positioned


public struct VelocityCalculator {
  
  /// Default weights: exponential decay favoring recent samples
  /// Index 0 = most recent pair, higher indices = older pairs
  ///
  /// I previously had: `[0.05, 0.1, 0.15, 0.25, 0.35, 0.1]`
  /// According to Claude:
  /// > Your original shows an interesting pattern - it peaks in the middle then drops.
  /// > Might be better for smoothing out very recent noise while still favoring recent data
  /// > My suggestion uses pure recency bias; best for responsive, real-time tracking
  public static let defaultWeights: [Double] = [0.4, 0.3, 0.2, 0.1]
  
  private let maxVelocity: Double
  private let minTimeDelta: TimeInterval
  private let maxHistoryDepth: Int
  private let minPointsForWeighted: Int
  
  public init(
    maxVelocity: Double = 400.0,
    minTimeDelta: TimeInterval = 0.001,
    maxHistoryDepth: Int = 10,
    minPointsForWeighted: Int = 3
  ) {
    self.maxVelocity = maxVelocity
    self.minTimeDelta = minTimeDelta
    self.maxHistoryDepth = maxHistoryDepth
    self.minPointsForWeighted = minPointsForWeighted
  }
  
  public func computeWeightedVelocity<T: TimestampedPosition>(
    from history: [T],
    weights: [Double] = defaultWeights
  ) -> CGVector {
    
    // Edge case: empty or insufficient history
    guard history.count >= 2 else { return .zero }
    
    // Edge case: empty weights array
    guard !weights.isEmpty else {
      // Fallback to simple calculation with last two points
      let lastTwo = Array(history.suffix(2))
      return computeSimpleVelocity(from: lastTwo[0], to: lastTwo[1])
    }
    
    // For small history, use simple calculation
    if history.count < minPointsForWeighted {
      let lastTwo = Array(history.suffix(2))
      return computeSimpleVelocity(from: lastTwo[0], to: lastTwo[1])
    }
    
    // Limit history depth for performance
    let recentHistory = Array(history.suffix(maxHistoryDepth))
    
    // Calculate weighted average with explicit recency bias
    var weightedDx: Double = 0
    var weightedDy: Double = 0
    var totalWeight: Double = 0
    
    // Process consecutive pairs, starting from most recent
    for i in 1..<recentHistory.count {
      let velocity = computeSimpleVelocity(
        from: recentHistory[i - 1],
        to: recentHistory[i]
      )
      
      // Weight index represents how recent this pair is
      // 0 = most recent pair, higher indices = older pairs
      let pairIndex = (recentHistory.count - 1) - i
      let weightIndex = min(pairIndex, weights.count - 1)
      let weight = weights[weightIndex]
      
      weightedDx += velocity.dx * weight
      weightedDy += velocity.dy * weight
      totalWeight += weight
    }
    
    // Safety check for total weight
    guard totalWeight > 0 else {
      // Fallback to simple calculation
      let lastTwo = Array(recentHistory.suffix(2))
      return computeSimpleVelocity(from: lastTwo[0], to: lastTwo[1])
    }
    
    let finalVelocity = CGVector(
      dx: weightedDx / totalWeight,
      dy: weightedDy / totalWeight
    )
    
    return finalVelocity.clampVelocity(maxVelocity: maxVelocity)
  }
  
  // MARK: - Helper methods
  
  private func computeSimpleVelocity<T: TimestampedPosition>(
    from pointA: T,
    to pointB: T
  ) -> CGVector {
    let dt = pointB.timestamp - pointA.timestamp
    guard dt >= minTimeDelta else { return .zero }
    
    return CGVector(
      dx: (pointB.position.x - pointA.position.x) / dt,
      dy: (pointB.position.y - pointA.position.y) / dt
    )
  }
  
//  private func clampVelocity(_ velocity: CGVector) -> CGVector {
//    let magnitude = sqrt(velocity.dx * velocity.dx + velocity.dy * velocity.dy)
//    guard magnitude > maxVelocity else { return velocity }
//    
//    let scale = maxVelocity / magnitude
//    return CGVector(
//      dx: velocity.dx * scale,
//      dy: velocity.dy * scale
//    )
//  }
}

// MARK: - Alternative weight generation utilities

extension VelocityCalculator {
  
  /// Generate exponential decay weights
  /// - Parameter count: Number of weights to generate
  /// - Parameter decayFactor: How quickly weights decrease (0.5 = half each step)
  public static func exponentialWeights(count: Int, decayFactor: Double = 0.7) -> [Double] {
    guard count > 0 else { return [] }
    
    var weights = (0..<count).map { i in
      pow(decayFactor, Double(i))
    }
    
    // Normalize so they sum to 1.0
    let sum = weights.reduce(0, +)
    if sum > 0 {
      weights = weights.map { $0 / sum }
    }
    
    return weights
  }
  
  /// Generate linear decay weights (most recent gets highest weight)
  public static func linearWeights(count: Int) -> [Double] {
    guard count > 0 else { return [] }
    
    let weights = (0..<count).map { i in
      Double(count - i)
    }
    
    let sum = weights.reduce(0, +)
    return weights.map { $0 / sum }
  }
}

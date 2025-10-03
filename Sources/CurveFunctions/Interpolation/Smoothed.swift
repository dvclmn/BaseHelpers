//
//  Smoothed.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 23/9/2025.
//

import Foundation

extension BinaryFloatingPoint {
  
  /// Smoothly approaches `target` using exponential smoothing
  /// - Parameters:
  ///   - target: The target value to approach
  ///   - dt: Time since last update (seconds)
  ///   - timeConstant: Smoothing time constant τ (seconds) - time to reach ~63% of target
  /// - Returns: Updated value
  ///
  /// Notes:
  /// `timeConstant` controls how quickly the smoothing converges toward the target value
  ///
  /// Read more in Bear:
  /// bear://x-callback-url/open-note?id=65D4914D-3835-4F79-B8D0-4820B68B7F1B
  public func smoothed(
    towards target: Self,
    dt: Self,
    timeConstant: Self
  ) -> Self {
    /// Snap on first frame, or if timeConstant is too small
    /// Very small time constants would cause erratic behavior
    guard dt > 0 else { return target }
    guard timeConstant > 0.001 else { return target }
    
    /// Calculate the ratio of elapsed time to time constant
    /// This determines how much "decay" should occur
    let timeRatio = dt / timeConstant
    
    /// Calculate exponential decay factor
    /// exp(-timeRatio) represents how much of the OLD value to retain
    /// When timeRatio is small (`dt << τ`), decay ≈ 1 (keep most of old value)
    /// When timeRatio is large (`dt >> τ`), decay ≈ 0 (discard old value)
    let exponentialDecay = Self(exp(Double(-timeRatio)))
    
    /// Calculate the smoothing factor (learning rate)
    /// This represents how much to move toward the target
    /// alpha = 0 means no movement, alpha = 1 means jump directly to target
    let alpha = 1 - exponentialDecay
    
    /// Interpolate between current value and target
    /// `self + (target - self) * alpha` is equivalent to:
    /// `self * (1 - alpha) + target * alpha`
    let difference = target - self
    let adjustment = difference * alpha
    
    return self + adjustment
  }
  
  
}

//
//  Model+EasePresets.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 25/8/2025.
//

import Foundation

extension EasingFunction {
  // Convenience static properties for common easing functions
  public static let linear = EasingFunction(curve: .linear, direction: .in)
  
  public static let easeInSine = EasingFunction(curve: .sine, direction: .in)
  public static let easeOutSine = EasingFunction(curve: .sine, direction: .out)
  public static let easeInOutSine = EasingFunction(curve: .sine, direction: .inOut)
  
  public static let easeInQuad = EasingFunction(curve: .quadratic, direction: .in)
  public static let easeOutQuad = EasingFunction(curve: .quadratic, direction: .out)
  public static let easeInOutQuad = EasingFunction(curve: .quadratic, direction: .inOut)
  
  public static let easeInCubic = EasingFunction(curve: .cubic, direction: .in)
  public static let easeOutCubic = EasingFunction(curve: .cubic, direction: .out)
  public static let easeInOutCubic = EasingFunction(curve: .cubic, direction: .inOut)
  
  // ... continue for all other curve types (Quart, Quint, Expo, etc.)
  public static let easeInBounce = EasingFunction(curve: .bounce, direction: .in)
  public static let easeOutBounce = EasingFunction(curve: .bounce, direction: .out)
  public static let easeInOutBounce = EasingFunction(curve: .bounce, direction: .inOut)
}

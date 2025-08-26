//
//  Model+EasePresets.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 25/8/2025.
//

import Foundation

//enum EasingPreset: String, CaseIterable, Identifiable {
//  // MARK: - Linear
//  case linear
//  
//  // MARK: - Sine
//  case easeInSine
//  case easeOutSine
//  case easeInOutSine
//  
//  // MARK: - Quadratic (t^2)
//  case easeInQuad
//  case easeOutQuad
//  case easeInOutQuad
//  
//  // MARK: - Cubic (t^3)
//  case easeInCubic
//  case easeOutCubic
//  case easeInOutCubic
//  
//  // MARK: - Quartic (t^4)
//  case easeInQuart
//  case easeOutQuart
//  case easeInOutQuart
//  
//  // MARK: - Quintic (t^5)
//  case easeInQuint
//  case easeOutQuint
//  case easeInOutQuint
//  
//  // MARK: - Exponential (2^t)
//  case easeInExpo
//  case easeOutExpo
//  case easeInOutExpo
//  
//  // MARK: - Circular (sqrt(1-t^2))
//  case easeInCirc
//  case easeOutCirc
//  case easeInOutCirc
//  
//  // MARK: - Back (Overshooting)
//  case easeInBack
//  case easeOutBack
//  case easeInOutBack
//  
//  // MARK: - Elastic (Spring-like)
//  case easeInElastic
//  case easeOutElastic
//  case easeInOutElastic
//  
//  // MARK: - Bounce
//  case easeInBounce
//  case easeOutBounce
//  case easeInOutBounce
//  
//  // MARK: - "Fun" or Custom Presets
//  case easeInSmoothedStep // Very smooth start/end
//  case easeOutSmoothedStep
//  case easeInOutSmoothedStep
//  
//  // A "bump" function that goes slightly above 1.0 and back
//  case easeOutBump
//  case easeInBump
//  
//  public var id: String { self.rawValue }
//  
//  public var curve: EasingFunction {
//    let function = EasingFunction(
//      curve: <#T##CurveFunction#>,
//      direction: <#T##EasingDirection#>
//    )
//  }
//}


//extension EasingFunction {
//  /// Convenience static properties for common easing functions
//  public static let linear = EasingFunction(.linear, .in)
//
//  public static let easeInSine = EasingFunction(.sine, .in)
//  public static let easeOutSine = EasingFunction(.sine, .out)
//  public static let easeInOutSine = EasingFunction(.sine, .inOut)
//
//  public static let easeInQuad = EasingFunction(.quadratic, .in)
//  public static let easeOutQuad = EasingFunction(.quadratic, .out)
//  public static let easeInOutQuad = EasingFunction(.quadratic, .inOut)
//
//  public static let easeInCubic = EasingFunction(.cubic, .in)
//  public static let easeOutCubic = EasingFunction(.cubic, .out)
//  public static let easeInOutCubic = EasingFunction(.cubic, .inOut)
//
//  public static let easeInBounce = EasingFunction(.bounce, .in)
//  public static let easeOutBounce = EasingFunction(.bounce, .out)
//  public static let easeInOutBounce = EasingFunction(.bounce, .inOut)
//}


import Foundation

//extension EasingPreset {
//  /// Calculates the eased progress for a given normalized time.
//  /// - Parameters:
//  ///   - t: The normalized time (from 0.0 to 1.0).
//  ///   - overshoot: The overshoot amount for `Back` and `Elastic` easings. Default is 1.70158.
//  /// - Returns: The eased progress, which may overshoot below 0.0 or above 1.0.
//  func progress(for t: Double, overshoot: Double = 1.70158) -> Double {
//    // Clamp t to the expected range for most functions.
//    // Some functions (elastic) are designed to work outside this range.
//    let t = t.clamped(to: 0...1)
//    
//    switch self {
//        // MARK: - Linear
//      case .linear:
//        return t
//        
        // MARK: - Sine
//      case .easeInSine:
//        return 1 - cos((t * .pi) / 2)
//      case .easeOutSine:
//        return sin((t * .pi) / 2)
//      case .easeInOutSine:
//        return -(cos(.pi * t) - 1) / 2
        
        // MARK: - Quadratic
//      case .easeInQuad:
//        return t * t
//      case .easeOutQuad:
//        return 1 - (1 - t) * (1 - t)
//      case .easeInOutQuad:
//        return t < 0.5 ? 2 * t * t : 1 - pow(-2 * t + 2, 2) / 2
        
        // MARK: - Cubic
//      case .easeInCubic:
//        return t * t * t
//      case .easeOutCubic:
//        return 1 - pow(1 - t, 3)
//      case .easeInOutCubic:
//        return t < 0.5 ? 4 * t * t * t : 1 - pow(-2 * t + 2, 3) / 2
        
     
        
        // MARK: - Exponential
//      case .easeInExpo:
//        return t == 0 ? 0 : pow(2, 10 * t - 10)
//      case .easeOutExpo:
//        return t == 1 ? 1 : 1 - pow(2, -10 * t)
//      case .easeInOutExpo:
//        if t == 0 { return 0 }
//        if t == 1 { return 1 }
//        return t < 0.5 ? pow(2, 20 * t - 10) / 2 : (2 - pow(2, -20 * t + 10)) / 2
        
        // MARK: - Circular
      
        
        // MARK: - Back (Overshoot)
      
        
//        // MARK: - Elastic
//      case .easeInElastic:
//        if t == 0 { return 0 }
//        if t == 1 { return 1 }
//        let period = 0.3
//        let c4 = (2 * .pi) / period
//        return -pow(2, 10 * t - 10) * sin((t * 10 - 10.75) * c4)
//      case .easeOutElastic:
//        if t == 0 { return 0 }
//        if t == 1 { return 1 }
//        let period = 0.3
//        let c4 = (2 * .pi) / period
//        return pow(2, -10 * t) * sin((t * 10 - 0.75) * c4) + 1
//      case .easeInOutElastic:
//        if t == 0 { return 0 }
//        if t == 1 { return 1 }
//        let period = 0.3 * 1.5
//        let c5 = (2 * .pi) / period
//        return t < 0.5
//        ? -(pow(2, 20 * t - 10) * sin((20 * t - 11.125) * c5)) / 2
//        : (pow(2, -20 * t + 10) * sin((20 * t - 11.125) * c5)) / 2 + 1
//        
        // MARK: - Bounce
//      case .easeInBounce:
//        return 1 - Self.easeOutBounce.progress(for: 1 - t)
//      case .easeOutBounce:
//        let n1 = 7.5625
//        let d1 = 2.75
//        
//        if t < 1 / d1 {
//          return n1 * t * t
//        } else if t < 2 / d1 {
//          return n1 * (t - 1.5 / d1) * t + 0.75
//        } else if t < 2.5 / d1 {
//          return n1 * (t - 2.25 / d1) * t + 0.9375
//        } else {
//          return n1 * (t - 2.625 / d1) * t + 0.984375
//        }
//      case .easeInOutBounce:
//        return t < 0.5
//        ? (1 - Self.easeOutBounce.progress(for: 1 - 2 * t)) / 2
//        : (1 + Self.easeOutBounce.progress(for: 2 * t - 1)) / 2
        
        // MARK: - "Fun" or Custom Presets
//      case .easeInSmoothedStep:
//        // smoothstep (S-curve)
//        return t * t * (3 - 2 * t)
//      case .easeOutSmoothedStep:
//        let invertedT = 1 - t
//        return 1 - (invertedT * invertedT * (3 - 2 * invertedT))
//      case .easeInOutSmoothedStep:
//        // smootherstep (even smoother S-curve)
//        return t * t * t * (t * (t * 6 - 15) + 10)
//        
//      case .easeOutBump:
//        // Creates a small bump that goes above 1.0 and comes back
//        let bumpHeight = 0.2
//        let bumpPosition = 0.8
//        if t <= bumpPosition {
//          // Use a standard easeOut to the peak
//          let normalizedT = t / bumpPosition
//          let progressToPeak = 1 - (1 - normalizedT) * (1 - normalizedT) // easeOutQuad
//          return progressToPeak
//        } else {
//          // After the peak, fall back down to 1.0
//          let fallDistance = (1 + bumpHeight) - 1.0
//          let normalizedT = (t - bumpPosition) / (1 - bumpPosition) // t from 0 to 1 for the fall
//          let easeOutFall = 1 - (1 - normalizedT) * (1 - normalizedT) // easeOutQuad for the fall
//          return (1 + bumpHeight) - fallDistance * easeOutFall
//        }
//      case .easeInBump:
//        // For consistency, an easeInBump could start below 0
//        // This is a simpler, less common implementation
//        let invertedT = 1 - t
//        return 1 - Self.easeOutBump.progress(for: invertedT)
//    }
//  }
//}

// A small helper extension to clamp values
//extension Comparable {
//  func clamped(to limits: ClosedRange<Self>) -> Self {
//    return min(max(self, limits.lowerBound), limits.upperBound)
//  }
//}

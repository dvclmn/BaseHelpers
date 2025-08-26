//
//  Model+Ease.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 25/8/2025.
//

import Foundation

public enum EasingDirection: String, CaseIterable, Identifiable, Sendable {
  case `in`
  case out
  case inOut

  public var id: String { rawValue }
}

public struct EasingFunction: Hashable, Identifiable, Sendable {
  public var curve: CurveFunction
  public var direction: EasingDirection

  public init(_ curve: CurveFunction, _ direction: EasingDirection) {
    self.curve = curve
    self.direction = direction
  }

  /// A unique identifier, e.g., `easeInSine`, `easeOutCubic`
  public var id: String {
    /// For linear, the direction is irrelevant, so we just return "linear"
    if curve == .linear {
      return "linear"
    }
    return "ease\(direction.rawValue)\(curve.rawValue.capitalized)"
  }
}

extension EasingFunction {
  /// Calculates the interpolated value for a given time.
  /// - Parameter x: A value between 0.0 (start) and 1.0 (end).
  /// - Returns: The interpolated value, often but not always between 0.0 and 1.0 (e.g., `back` can overshoot).
  public func value(for x: Double) -> Double {
    /// Ensure input is within the standard `[0, 1]` range
    let t = max(0, min(1, x))

    switch (curve, direction) {
      // MARK: - Linear
      case (.linear, _):
        return t  // Direction doesn't matter for linear

      // MARK: - Sine (Trigonometric)
      case (.sine, .in):
        return 1 - cos((t * .pi) / 2)

      case (.sine, .out):
        return sin((t * .pi) / 2)

      case (.sine, .inOut):
        return -(cos(.pi * t) - 1) / 2

      // MARK: - Quadratic (t^2)
      case (.quadratic, .in):
        return t * t

      case (.quadratic, .out):
        return 1 - (1 - t) * (1 - t)

      case (.quadratic, .inOut):
        return t < 0.5 ? 2 * t * t : 1 - pow(-2 * t + 2, 2) / 2

      // MARK: - Cubic (t^3)
      case (.cubic, .in):
        return t * t * t

      case (.cubic, .out):
        return 1 - pow(1 - t, 3)

      case (.cubic, .inOut):
        return t < 0.5 ? 4 * t * t * t : 1 - pow(-2 * t + 2, 3) / 2

      // MARK: - Quartic
      case (.quartic, .in):
        return t * t * t * t
      case (.quartic, .out):
        return 1 - pow(1 - t, 4)
      case (.quartic, .inOut):
        return t < 0.5 ? 8 * pow(t, 4) : 1 - pow(-2 * t + 2, 4) / 2

      // MARK: - Quintic
      case (.quintic, .in):
        return pow(t, 5)
      case (.quintic, .out):
        return 1 - pow(1 - t, 5)
      case (.quintic, .inOut):
        return t < 0.5 ? 16 * pow(t, 5) : 1 - pow(-2 * t + 2, 5) / 2

      // MARK: - Bounce (Simulating a bounce)
      case (.bounce, .in):
        return bounceIn(t)

      case (.bounce, .out):
        return bounceOut(t)

      case (.bounce, .inOut):
        return bounceInOut(t)

      // MARK: - Expontential
      case (.exponential, .in):
        return t == 0 ? 0 : pow(2, 10 * t - 10)

      case (.exponential, .out):
        return t == 1 ? 1 : 1 - pow(2, -10 * t)

      case (.exponential, .inOut):
        if t == 0 { return 0 }
        if t == 1 { return 1 }
        return t < 0.5 ? pow(2, 20 * t - 10) / 2 : (2 - pow(2, -20 * t + 10)) / 2

        // MARK: - Circular
      case (.circular, .in):
        return 1 - sqrt(1 - pow(t, 2))
        
      case (.circular, .out):
        return sqrt(1 - pow(t - 1, 2))
        
      case (.circular, .inOut):
        return t < 0.5
        ? (1 - sqrt(1 - pow(2 * t, 2))) / 2
        : (sqrt(1 - pow(-2 * t + 2, 2)) + 1) / 2
        
        
      default:
        // Fallback for unimplemented functions
        print("Easing function \(id) not yet implemented. Returning linear.")
        return t
    }
  }
}

extension EasingFunction {


  // MARK: - Bounce Implementation

  private func bounceOut(_ t: Double) -> Double {
    let n1 = 7.5625
    let d1 = 2.75

    if t < 1 / d1 {
      return n1 * t * t
    } else if t < 2 / d1 {
      let t2 = t - 1.5 / d1
      return n1 * t2 * t2 + 0.75
    } else if t < 2.5 / d1 {
      let t2 = t - 2.25 / d1
      return n1 * t2 * t2 + 0.9375
    } else {
      let t2 = t - 2.625 / d1
      return n1 * t2 * t2 + 0.984375
    }
  }

  private func bounceIn(_ t: Double) -> Double {
    return 1 - bounceOut(1 - t)
  }

  private func bounceInOut(_ t: Double) -> Double {
    return t < 0.5
      ? (1 - bounceOut(1 - 2 * t)) / 2
      : (1 + bounceOut(2 * t - 1)) / 2
  }

  // MARK: - Elastic Implementation

  private func elastic(
    _ t: Double,
    direction: EasingDirection,
    amplitude: Double = 1,
    period: Double = 0.3
  ) -> Double {
    guard t != 0, t != 1 else { return t }

    /// Convert period to angular frequency constant
    let c = (2 * Double.pi) / period

    switch direction {
      case .in:
        return -amplitude * pow(2, 10 * (t - 1)) * sin((t * 10 - 10.75) * c)

      case .out:
        return amplitude * pow(2, -10 * t) * sin((t * 10 - 0.75) * c) + 1

      case .inOut:
        /// The inOut variant typically uses a different period factor
        let periodInOut = period * 1.5
        let cInOut = (2 * Double.pi) / periodInOut
        guard t < 0.5 else {
          return (pow(2, -20 * t + 10) * sin((20 * t - 11.125) * cInOut)) / 2 + 1
        }
        return -(pow(2, 20 * t - 10) * sin((20 * t - 11.125) * cInOut)) / 2
    }
  }

  //  private func elasticIn(_ t: Double) -> Double {
  //    guard t != 0, t != 1 else { return t }
  //    let c4 = (2 * Double.pi) / 3
  //    return -pow(2, 10 * (t - 1)) * sin((t * 10 - 10.75) * c4)
  //  }
  //
  //  private func elasticOut(_ t: Double) -> Double {
  //    guard t != 0, t != 1 else { return t }
  //    let c4 = (2 * Double.pi) / 3
  //    return pow(2, -10 * t) * sin((t * 10 - 0.75) * c4) + 1
  //  }
  //
  //  private func elasticInOut(_ t: Double) -> Double {
  //    guard t != 0, t != 1 else { return t }
  //    let c5 = (2 * Double.pi) / 4.5
  //    if t < 0.5 {
  //      return -(pow(2, 20 * t - 10) * sin((20 * t - 11.125) * c5)) / 2
  //    } else {
  //      return (pow(2, -20 * t + 10) * sin((20 * t - 11.125) * c5)) / 2 + 1
  //    }
  //  }
}

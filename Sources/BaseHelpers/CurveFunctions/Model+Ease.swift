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

// 4. The Calculator

/// This extension contains the logic to compute a value for a given time.
///
/// ```
/// // Method 1: Using the predefined static vars (most common and readable)
/// let bounceFunction = EasingFunction.easeOutBounce
/// let value = bounceFunction.value(for: 0.75)
///
/// // Method 2: Constructing dynamically (great for user-selected settings)
/// let userSelectedCurve: CurveFunction = .sine
/// let userSelectedDirection: EasingDirection = .inOut
/// let dynamicFunction = EasingFunction(curve: userSelectedCurve, direction: userSelectedDirection)
///
/// // You can easily get a list of all possible functions for a UI
/// let allPossibleFunctions: [EasingFunction] = CurveFunction.allCases.flatMap { curve in
///   // Linear only has one variant, others have three (.in, .out, .inOut)
///   if curve == .linear {
///     return [EasingFunction(curve: curve, direction: .in)] // direction is ignored
///   } else {
///     return EasingDirection.allCases.map { direction in
///       EasingFunction(curve: curve, direction: direction)
///     }
///   }
/// }
/// ```
extension EasingFunction {
  /// Calculates the interpolated value for a given time.
  /// - Parameter x: A value between 0.0 (start) and 1.0 (end).
  /// - Returns: The interpolated value, often but not always between 0.0 and 1.0 (e.g., `back` can overshoot).
  public func value(for x: Double) -> Double {
    // Ensure input is within the standard [0, 1] range
    let t = max(0, min(1, x))

    switch (curve, direction) {
      // MARK: - Linear
      case (.linear, _):
        return t  // Direction doesn't matter for linear

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

      // MARK: - Sine (Trigonometric)
      case (.sine, .in):
        return 1 - cos((t * .pi) / 2)
      case (.sine, .out):
        return sin((t * .pi) / 2)
      case (.sine, .inOut):
        return -(cos(.pi * t) - 1) / 2

      // MARK: - Bounce (Simulating a bounce)
      case (.bounce, .out):
        return bounceOut(t)

      case (.bounce, .in):
        return bounceIn(t)

      case (.bounce, .inOut):
        return bounceInOut(t)

      default:
        // Fallback for unimplemented functions
        print("Easing function \(id) not yet implemented. Returning linear.")
        return t
    }
  }

  // MARK: - Usage Examples

  /// Quick test to visualize the curves
  //  public static func testCurves() {
  //    let testPoints = stride(from: 0.0, through: 1.0, by: 0.1)
  //
  //    print("Bounce curve:")
  //    for t in testPoints {
  //      let value = PresetCurve.bounce.apply(to: t)
  //      print("t: \(String(format: "%.1f", t)) -> \(String(format: "%.3f", value))")
  //    }
  //
  //    print("\nElastic curve:")
  //    for t in testPoints {
  //      let value = PresetCurve.elastic.apply(to: t)
  //      print("t: \(String(format: "%.1f", t)) -> \(String(format: "%.3f", value))")
  //    }
  //  }
}

extension EasingFunction {

  // MARK: - Expo
  private func expoIn(_ t: Double) -> Double {
    return t == 0 ? 0 : pow(2, 10 * t - 10)
  }

  private func expoOut(_ t: Double) -> Double {
    return t == 1 ? 1 : 1 - pow(2, -10 * t)
  }

  private func expoInOut(_ t: Double) -> Double {
    if t == 0 { return 0 }
    if t == 1 { return 1 }
    return t < 0.5 ? pow(2, 20 * t - 10) / 2 : (2 - pow(2, -20 * t + 10)) / 2
  }

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

  private func elasticOut(_ t: Double) -> Double {
    let c4 = (2 * Double.pi) / 3

    if t == 0 {
      return 0
    } else if t == 1 {
      return 1
    } else {
      return pow(2, -10 * t) * sin((t * 10 - 0.75) * c4) + 1
    }
  }

  private func elasticIn(_ t: Double) -> Double {
    let c4 = (2 * Double.pi) / 3

    if t == 0 {
      return 0
    } else if t == 1 {
      return 1
    } else {
      return -pow(2, 10 * (t - 1)) * sin((t * 10 - 10.75) * c4)
    }
  }

  private func elasticInOut(_ t: Double) -> Double {
    let c5 = (2 * Double.pi) / 4.5

    if t == 0 {
      return 0
    } else if t == 1 {
      return 1
    } else if t < 0.5 {
      return -(pow(2, 20 * t - 10) * sin((20 * t - 11.125) * c5)) / 2
    } else {
      return (pow(2, -20 * t + 10) * sin((20 * t - 11.125) * c5)) / 2 + 1
    }
  }
}

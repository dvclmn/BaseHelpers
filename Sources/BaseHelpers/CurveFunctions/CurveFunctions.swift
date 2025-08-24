//
//  ValueCurveType.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 15/5/2025.
//

import Foundation

/// A list of pure mathematical curves.
///
/// All functions here are intended to operate on **normalised values**,
/// where the input `x` is in the range `0...1`, and the output is also
/// scaled to `0...1` for practical use in animation, design, or UI contexts.
///
/// ## Linear
/// A relationship where change is proportional to input.
/// `y = mx + b`
/// - The graph is a straight line.
/// - Each step increases by exactly the same amount.
///
/// ## Quadratic
/// Second-degree polynomial.
/// `y = ax² + bx + c`
/// - The graph is a parabola (U-shaped curve).
/// - Useful for accelerations or decelerations.
/// - Common in projectile motion in physics.
///
/// ## Cubic
/// Third-degree polynomial.
/// `y = ax³ + bx² + cx + d`
/// - Can produce sharper curvature than quadratic functions.
/// - Often used for smooth acceleration/deceleration in animation.
/// - Basis for cubic Bézier curves, common in easing functions.
///
/// ## Exponential
/// Growth or decay proportional to the current value.
/// `y = a · bˣ`
/// - Steeper change than polynomial functions.
/// - Models rapid growth or rapid fade.
/// - Used in animation for fast acceleration, and in audio for volume changes.
///
/// ## Logarithmic
/// Inverse of the exponential function.
/// `y = log_b(x)`
/// - Starts steep and flattens out over time.
/// - Useful for compressing wide ranges into smaller scales.
/// - Models diminishing returns or gradual slow-downs.
///

public enum CurveFunction: String, CaseIterable, Identifiable, Sendable {
  case linear
  case quadratic
  case cubic
  case exponential
  case logarithmic

  public var id: String { self.rawValue }

  public var name: String {
    switch self {
      case .linear: "Linear"
      case .quadratic: "Quadratic"
      case .cubic: "Cubic"
      case .exponential: "Exponential"
      case .logarithmic: "Logarithmic"
    }
  }

  /// Applies the curve to a normalised input in the range `0...1`,
  /// returning a normalised output in `0...1`.
  public func apply(to x: Double) -> Double {
    let clamped = max(0, min(1, x))
    switch self {
      case .linear:
        return clamped

      case .quadratic:
        /// Simple ease-in: y = x²
        return clamped * clamped

      case .cubic:
        /// Simple ease-in: y = x³
        return clamped * clamped * clamped

      case .exponential:
        /// Normalised exponential (ease-in style)
        /// Adjust exponent for desired steepness
        let exponent = 5.0
        return (pow(2, exponent * clamped) - 1) / (pow(2, exponent) - 1)

      case .logarithmic:
        /// Normalised log (inverse of exponential)
        let base = 10.0
        return log(1 + (base - 1) * clamped) / log(base)

    //      case .sine:
    //        /// Half sine wave from 0 to 1
    //        return 0.5 - 0.5 * cos(clamped * .pi)
    }
  }

  public func value(
    at position: Double,
    min: Double,
    max: Double,
    steps: Int? = nil
  ) -> Double {
    let y = apply(to: position)  // normalised 0...1 curve output
    var mapped = min + (max - min) * y

    if let steps, steps > 1 {
      let stepSize = (max - min) / Double(steps - 1)
      mapped = round(mapped / stepSize) * stepSize
    }

    return mapped
  }
}

public enum CurveType: Identifiable, Sendable {
  case shaped(CurveFunction, Ease)  // Composable curves
  case preset(PresetCurve)
  //  case sine
  //  case elastic
  //  case bounce

  public var id: String {
    switch self {
      case .shaped(let curve, let ease): return "\(curve.rawValue)_\(ease.rawValue)"
      case .preset(let preset): return preset.rawValue
    //      case sine:
    //      case elastic:
    //      case bounce:
    }
  }
}

public enum Ease: String, CaseIterable, Identifiable, Sendable {
  case `in`
  case out
  case inOut
  case none

  public var id: String { rawValue }

  public func apply(
    using curve: CurveFunction,
    //    using curve: (Double) -> Double,
    to x: Double
  ) -> Double {
    let clamped = max(0, min(1, x))
    switch self {
      case .none:
        return curve.apply(to: clamped)

      case .in:
        return curve.apply(to: clamped)

      case .out:
        return 1 - curve.apply(to: (1 - clamped))
      case .inOut:
        guard clamped < 0.5 else {
          return 0.5 + 0.5 * (1 - curve.apply(to: (1 - clamped) * 2))
        }
        return 0.5 * curve.apply(to: clamped * 2)
    }
  }
}

/// Discrete scaling system used in design
public struct ModularScale {
  var base: Double
  var ratio: Double

  public init(base: Double, ratio: Double) {
    self.base = base
    self.ratio = ratio
  }

  public func value(forStep step: Int) -> Double {
    base * pow(ratio, Double(step))
  }
}

//public struct ValueCurve {
//  public let apply: (Double) -> Double
//}
//
//public enum ValueCurveType: String, CaseIterable, Identifiable {
//  case linear
//  case quadratic
//  case cubic
//  case exponential
//  case logarithmic
//  case sine
//  case modularScale
//
//  public var id: String { self.rawValue }
//
//  public var name: String {
//    switch self {
//      case .linear: "Linear"
//      case .quadratic: "Quadratic"
//      case .cubic: "Cubic"
//      case .exponential: "Exponential"
//      case .logarithmic: "Logarithmic"
//      case .sine: "Sine"
//      case .modularScale: "Modular Scale"
//
//    }
//  }
//
//  public func calculateValue(
//    at position: Double,
//    min: Double,
//    max: Double,
//    // For modular scale only, should revise
//    baseRatio: Double? = nil,
//    steps: Int? = nil
//  ) -> Double {
//    let range = max - min
//
//    switch self {
//      case .linear:
//        return min + range * position
//
//      case .quadratic:
//        return min + range * pow(position, 2)
//
//      case .cubic:
//        return min + range * pow(position, 3)
//
//      case .exponential:
//        return min + range * pow(position, 2)
//
//      case .logarithmic:
//        if position == 0 {
//          return min
//        }
//        let logValue = log(position + 1) / log(2)
//        return min + range * (logValue / log(2))
//
//
//      case .sine:
//        /// Sine curve from 0 to π/2 gives a nice easing
//        return min + range * sin(position * .pi / 2)
//
//      case .modularScale:
//
//        guard let baseRatio, let steps else {
//          print("Need to supply both baseRatio and steps for modular scale")
//          return .zero
//        }
//        /// Modular scale uses a ratio multiplied by itself for each step
//        if position == 0 {
//          return min
//        }
//        let stepsResult = position * Double(steps - 1)
//        return min * pow(baseRatio, stepsResult)
//    }
//  }
//}

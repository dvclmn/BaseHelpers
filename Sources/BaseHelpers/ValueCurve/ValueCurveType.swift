//
//  ValueCurveType.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 15/5/2025.
//

import Foundation

/// A list of pure mathematical curves
///
/// ## Linear
/// A relationship where change is proportional to input.
/// `y = mx + b`
/// - The graph is a straight line
/// - Each step increases by exactly the same amount.
///
/// ## Quadratic
/// Second-degree polynomial.
/// `y = ax^2 + bx + c`
/// - The graph is a parabola (U-shaped curve).
/// - Useful for accelerations or decelerations
/// - Common in projectile motion in physics
enum CurveFunction {
  case linear
  case quadratic
  case cubic
  case exponential
  case logarithmic
  case sine
}

/// Behavioural wrappers for applying curves
enum EasingType {
  case easeIn
  case easeOut
  case easeInOut
}
struct Easing {
  var type: EasingType
  var curve: CurveFunction
}

/// Discrete scaling system used in design
struct ModularScale {
  var base: Double
  var ratio: Double
  func value(forStep step: Int) -> Double {
    base * pow(ratio, Double(step))
  }
}


public struct ValueCurve {
  public let apply: (Double) -> Double
}

public enum ValueCurveType: String, CaseIterable, Identifiable {
  case linear
  case quadratic
  case cubic
  case exponential
  case logarithmic
  case sine
  case modularScale

  public var id: String { self.rawValue }

  public var name: String {
    switch self {
      case .linear: "Linear"
      case .quadratic: "Quadratic"
      case .cubic: "Cubic"
      case .exponential: "Exponential"
      case .logarithmic: "Logarithmic"
      case .sine: "Sine"
      case .modularScale: "Modular Scale"

    }
  }

  public func calculateValue(
    at position: Double,
    min: Double,
    max: Double,
    // For modular scale only, should revise
    baseRatio: Double? = nil,
    steps: Int? = nil
  ) -> Double {
    let range = max - min

    switch self {
      case .linear:
        return min + range * position

      case .quadratic:
        return min + range * pow(position, 2)

      case .cubic:
        return min + range * pow(position, 3)

      case .exponential:
        return min + range * pow(position, 2)

      case .logarithmic:
        if position == 0 {
          return min
        }
        let logValue = log(position + 1) / log(2)
        return min + range * (logValue / log(2))


      case .sine:
        /// Sine curve from 0 to π/2 gives a nice easing
        return min + range * sin(position * .pi / 2)

      case .modularScale:
        
        guard let baseRatio, let steps else {
          print("Need to supply both baseRatio and steps for modular scale")
          return .zero
        }
        /// Modular scale uses a ratio multiplied by itself for each step
        if position == 0 {
          return min
        }
        let stepsResult = position * Double(steps - 1)
        return min * pow(baseRatio, stepsResult)
    }
  }
}

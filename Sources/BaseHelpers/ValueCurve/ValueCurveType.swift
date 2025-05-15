//
//  ValueCurveType.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 15/5/2025.
//

import Foundation

public struct ValueCurve {
  public let type: ValueCurveType
//  public let customFunction: ((Double) -> Double)?

  public init(
    _ type: ValueCurveType,
//    custom: ((Double) -> Double)? = nil
  ) {
    self.type = type
//    self.customFunction = custom
  }

  public func apply(to value: CGFloat) -> CGFloat {
    let f = type.function(custom: nil)
//    let f = type.function(custom: customFunction)
    return CGFloat(f(Double(value)))
  }
}

public enum ValueCurveType: String, CaseIterable, Identifiable {
  case linear
  case quadratic
  case cubic
  case exponential
  case logarithmic
  case sine
  case modularScale
//  case custom

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
//      case .custom: "Custom"
    }
  }

  public func function(custom: ((Double) -> Double)? = nil) -> (Double) -> Double {
    switch self {
      case .linear:
        return { $0 }
      case .quadratic:
        return { pow($0, 2) }
      case .cubic:
        return { pow($0, 3) }
      case .exponential:
        return { 1 - exp(-$0 * 3) }
      case .logarithmic:
        return { log2($0 + 1) }  // or adjust as needed
      case .sine:
        return { sin($0 * .pi / 2) }
      case .modularScale:
        return { pow(1.25, $0 * 10) }  // example modular scale
//      case .custom:
//        guard let custom = custom else {
//          fatalError("Custom curve requires a provided function.")
//        }
//        return custom
    }
  }
}

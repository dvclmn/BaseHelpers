//
//  ValueCurveType.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 15/5/2025.
//

import Foundation

//public struct ValueCurve {
//  public let transform: (Double) -> Double
//  public func callAsFunction(_ input: Double) -> Double {
//    transform(input)
//  }
//}

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
  //  case modularScale
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
  
    }
  }
  /// `$0` is shorthand for the first (and in this case, only) argument passed
  /// into the closure in `ValueCurve`. So, passing a closure of type
  /// `(Double) -> Double` to `ValueCurve.init(apply:)`
  public func asCurve() -> ValueCurve {
    switch self {
      case .linear:
        return ValueCurve { $0 }
      case .exponential:
        return ValueCurve { pow($0, 2) }
      case .logarithmic:
        return ValueCurve { $0 == 0 ? 0 : log($0 + 1) / log(2) }
      case .quadratic:
        return ValueCurve { pow($0, 2) }
      case .cubic:
        return ValueCurve { pow($0, 3) }
      case .sine:
        return ValueCurve { sin($0 * .pi / 2) }
    }
  }
  //  public func asCurve(using params: CurveParameters = .init()) -> ValueCurve {
  //    switch self {
  //      case .linear:
  //        return ValueCurve { $0 }
  //
  //      case .exponential:
  //        return ValueCurve { pow($0, 2) }
  //
  //      case .logarithmic:
  //        return ValueCurve { $0 == 0 ? 0 : log($0 + 1) / log(2) }
  //
  //      case .quadratic:
  //        return ValueCurve { pow($0, 2) }
  //
  //      case .cubic:
  //        return ValueCurve { pow($0, 3) }
  //
  //      case .sine:
  //        return ValueCurve { sin($0 * .pi / 2) }
  //
  ////      case .modularScale:
  ////        let base = params.baseRatio ?? 1.125
  ////        let steps = Double(params.steps ?? 10)
  ////        return ValueCurve { position in
  ////          let i = position * (steps - 1)
  ////          return pow(base, i)
  ////        }
  //    }
  //  }
}

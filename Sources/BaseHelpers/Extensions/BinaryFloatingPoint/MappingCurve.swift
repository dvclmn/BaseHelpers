//
//  MappingCurve.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 24/8/2025.
//

import Foundation

public enum MappingCurve: Sendable {
  case linear
//  case eased(EasingType)
//  case easeIn(Double)   // e.g. pow(x, 2)
//  case easeOut(Double)  // e.g. pow(x, 0.5)
//  case easeInOut
  case other(CurveFunction)
  
  public func apply(_ x: Double) -> Double {
//    switch self {
//      case .linear:
//        return x
//        
//      case .easeIn(let power):
//        return pow(x, power)
//        
//      case .easeOut(let power):
//        return pow(x, 1 / power)
//        
//      case .easeInOut:
//        // cosine-based ease-in-out
//        return 0.5 - 0.5 * cos(.pi * x)
//        
//      case .other(let fn):
//        return fn.apply(to: x)
//    }
  }
}

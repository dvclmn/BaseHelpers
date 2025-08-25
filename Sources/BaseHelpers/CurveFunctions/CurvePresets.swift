//
//  CurvePresets.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 25/8/2025.
//

import Foundation

//public enum PresetCurve: String, CaseIterable, Identifiable, Sendable {
//  case sine
//  case bounce
//  case elastic
//  
//  public var id: String { rawValue }
//  
//  public func apply(to x: Double) -> Double {
//    let clamped = max(0, min(1, x))
//    switch self {
//      case .sine:
//        return 0.5 - 0.5 * cos(clamped * .pi)
//        
//      case .bounce:
//        return bounceOut(clamped)
//        
//      case .elastic:
//        return elasticOut(clamped)
//    }
//  }
//  
//  
//  
//
//}

// MARK: - Extended PresetCurve with Easing Variants

//public enum PresetCurveWithEasing: String, CaseIterable, Identifiable, Sendable {
//  // Sine (already ease-in-out by nature)
//  case sine
//  
//  // Bounce variants
//  case bounceIn = "bounce-in"
//  case bounceOut = "bounce-out"
//  case bounceInOut = "bounce-in-out"
//  
//  // Elastic variants
//  case elasticIn = "elastic-in"
//  case elasticOut = "elastic-out"
//  case elasticInOut = "elastic-in-out"
//  
//  public var id: String { rawValue }
//  
//  public func apply(to x: Double) -> Double {
//    let clamped = max(0, min(1, x))
//    switch self {
//      case .sine:
//        return 0.5 - 0.5 * cos(clamped * .pi)
//        
//      case .bounceIn:
//        return bounceIn(clamped)
//      case .bounceOut:
//        
//      case .bounceInOut:
//        return bounceInOut(clamped)
//        
//      case .elasticIn:
//        return elasticIn(clamped)
//      case .elasticOut:
//        return elasticOut(clamped)
//      case .elasticInOut:
//        return elasticInOut(clamped)
//    }
//  }
//}

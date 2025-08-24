//
//  CurvePresets.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 25/8/2025.
//

import Foundation

public enum PresetCurve: String, CaseIterable, Identifiable, Sendable {
  case sine
  case bounce
  case elastic
  
  public var id: String { rawValue }
  
  public func apply(to x: Double) -> Double {
    let clamped = max(0, min(1, x))
    switch self {
      case .sine:
        return 0.5 - 0.5 * cos(clamped * .pi)
        
      case .bounce:
        return bounceOut(clamped)
        
      case .elastic:
        return elasticOut(clamped)
    }
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

// MARK: - Extended PresetCurve with Easing Variants

public enum PresetCurveWithEasing: String, CaseIterable, Identifiable, Sendable {
  // Sine (already ease-in-out by nature)
  case sine
  
  // Bounce variants
  case bounceIn = "bounce-in"
  case bounceOut = "bounce-out"
  case bounceInOut = "bounce-in-out"
  
  // Elastic variants
  case elasticIn = "elastic-in"
  case elasticOut = "elastic-out"
  case elasticInOut = "elastic-in-out"
  
  public var id: String { rawValue }
  
  public func apply(to x: Double) -> Double {
    let clamped = max(0, min(1, x))
    switch self {
      case .sine:
        return 0.5 - 0.5 * cos(clamped * .pi)
        
      case .bounceIn:
        return bounceIn(clamped)
      case .bounceOut:
        return bounceOut(clamped)
      case .bounceInOut:
        return bounceInOut(clamped)
        
      case .elasticIn:
        return elasticIn(clamped)
      case .elasticOut:
        return elasticOut(clamped)
      case .elasticInOut:
        return elasticInOut(clamped)
    }
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

// MARK: - Usage Examples

extension PresetCurve {
  /// Quick test to visualize the curves
  public static func testCurves() {
    let testPoints = stride(from: 0.0, through: 1.0, by: 0.1)
    
    print("Bounce curve:")
    for t in testPoints {
      let value = PresetCurve.bounce.apply(to: t)
      print("t: \(String(format: "%.1f", t)) -> \(String(format: "%.3f", value))")
    }
    
    print("\nElastic curve:")
    for t in testPoints {
      let value = PresetCurve.elastic.apply(to: t)
      print("t: \(String(format: "%.1f", t)) -> \(String(format: "%.3f", value))")
    }
  }
}

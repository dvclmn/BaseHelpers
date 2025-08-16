//
//  EasingFunctions.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 16/8/2025.
//

import Foundation

enum EasingCurve {
  case easeInOutCubic
  case easeInBack
  case easeInElastic
  
  func curveFunction(_ x: Double) -> Double {
    
    switch self {
      case .easeInOutCubic:
        guard x < 0.5 else {
          return 1 - pow(-2 * x + 2, 3) / 2
        }
        return 4 * x * x * x
        
      case .easeInBack:
        let overshoot = 1.70158
        let overshootPlusOne = overshoot + 1
        return overshootPlusOne * x * x * x - overshoot * x * x
        
      case .easeInElastic:
        
        /// How many cycles of oscillation occur during the animation
        let elasticFrequency = (2 * Double.pi) / 3
        
        if x == 0 { return 0 }
        if x == 1 { return 1 }
        
        return -pow(2, 10 * x - 10) * sin((x * 10 - 10.75) * elasticFrequency)
        
    } // END switch
    
  }
}

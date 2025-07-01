//
//  Model+LumaLevel.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 1/7/2025.
//

import Foundation


struct LuminanceLevelAdjustment: HSVModifier {
  let level: LuminanceLevel
//  let purpose: ColourPurpose
  
  func adjustment(for colour: HSVColour) -> HSVAdjustment {
    
    switch level {
      case .dark:
        /// Dark, leg
        HSVAdjustment(
          hue: -18,
          saturation: -0.01,
          brightness: 0.75
        )
        
      case .light:
        /// Light, leg
        HSVAdjustment(
          hue: -16,
          saturation: 0.35,
          brightness: -0.75
        )
        
    }
  }
}

struct ColourPurposeAdjustment: HSVModifier {
  let purpose: ColourPurpose
  //  let purpose: ColourPurpose
  
  func adjustment(for colour: HSVColour) -> HSVAdjustment {
    
    switch purpose {
      case .legibility:


        
        /// Dark, leg
        HSVAdjustment(
          hue: -18,
          saturation: -0.01,
          brightness: 0.75
        )
        
        
        /// Light, leg
        HSVAdjustment(
          hue: -16,
          saturation: 0.35,
          brightness: -0.75
        )
        
      case .complimentary:
        
        
        
        /// Light, comp
        HSVAdjustment(
          hue: -10,
          saturation: 0.3,
          brightness: -0.5
        )
        
        /// light com
        HSVAdjustment(
          hue: -22,
          saturation: -0.08,
          brightness: 0.65
        )

        
    }
  }
}


/// Dark, comp



//struct LuminanceLevelAdjustment: HSVModifier {
//  let level: LuminanceLevel
//  let purpose: ColourPurpose
//  
//  func adjustment(for colour: HSVColour) -> HSVAdjustment {
//    
//    
//    switch self {
//      case .dark:
//        switch purpose {
//          case .legibility:
//            
//            
//          case .complimentary:
//           
//        }
//        
//      case .light:
//        switch purpose {
//          case .legibility:
//           
//          case .complimentary:
//            
//        }
//    }
//    
//    
//    
//    
//    switch (level, purpose) {
//      case (.dark, .legibility):      return HSVAdjustment(hue: -18, saturation: -0.01, brightness: 0.75)
//      case (.dark, .complementary):   return HSVAdjustment(hue: -22, saturation: -0.08, brightness: 0.65)
//      case (.light, .legibility):     return HSVAdjustment(hue: -16, saturation: 0.35, brightness: -0.75)
//      case (.light, .complementary):  return HSVAdjustment(hue: -10, saturation: 0.3, brightness: -0.5)
//    }
//  }
//}

public enum LuminanceLevel {
  case dark
  case light
  
  public init(from colour: any ColourModel) {
    self = colour.luminance > 0.4 ? .light : .dark
  }
}
//
//  func adjustmentPreset(purpose: ContrastPurpose) -> HSVAdjustment {
//    switch self {
//      case .dark:
//        switch purpose {
//          case .legibility:
//            HSVAdjustment(
//              hue: -18,
//              saturation: -0.01,
//              brightness: 0.75
//            )
//            
//          case .complimentary:
//            HSVAdjustment(
//              hue: -22,
//              saturation: -0.08,
//              brightness: 0.65
//            )
//        }
//        
//      case .light:
//        switch purpose {
//          case .legibility:
//            HSVAdjustment(
//              hue: -16,
//              saturation: 0.35,
//              brightness: -0.75
//            )
//          case .complimentary:
//            HSVAdjustment(
//              hue: -10,
//              saturation: 0.3,
//              brightness: -0.5
//            )
//        }
//    }
//  }
//}

public enum ColourPurpose {
  case legibility
  case complimentary
}

public enum ContrastChroma {
  case saturated
  case standard
  case monochrome
}

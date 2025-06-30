//
//  Model+PrimitiveColour.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 30/6/2025.
//

import Foundation

public enum PrimitiveColour: String, Identifiable, CaseIterable, Sendable {
  case red
  case orange
  case yellow
  case green
  case blue
  case purple
  case brown
  case monochrome
  
  public var id: String {
    rawValue
  }
  
  public var sortIndex: Int {
    PrimitiveColour.allCases.firstIndex(of: self) ?? 0
  }
  
  public var swatches: [Swatch] {
    //      let allSwatches: [Swatch] = Swatch.allCases
    switch self {
      case .red:
        //          return allSwatches.filter { $0.rawValue.contains("red") }
        [
          .red50,
          .red50V,
          .asciiRed,
          .asciiMaroon,
          .neonPink,
        ]
        
      case .orange:
        [
          .orange30,
          .neonOrange,
          .peach20,
          .peach30,
          .peach30V,
          .peach40,
        ]
        
      case .yellow:
        [
          .neonYellow,
          .yellow30,
          .yellow40,
          .asciiYellow,
        ]
        
      case .green:
        [
          .lime30,
          .lime40,
          .green20,
          .green30V,
          .green50,
          .green70,
          .asciiGreen,
          .neonGreen,
          .teal30,
          .teal50,
          .asciiTeal,
          .asciiTealDull,
          .olive40,
          .olive70,
          
        ]
      case .blue:
        [
          .blue10,
          .blue20,
          .blue30,
          .blue40,
          .blue50,
          .blue60,
          .asciiBlue,
          .slate30,
          .slate40,
          .slate50,
          .slate60,
          .slate70,
          .slate80,
          .slate90,
        ]
        
      case .purple:
        [
          .purple20,
          .purple30,
          .purple40,
          .purple50,
          .purple70,
          .asciiPurple,
          .plum30,
          .plum40,
          .plum50,
          .plum60,
          .plum70,
          .plum80,
          .plum90,
        ]
        
      case .brown:
        [
          .brown30,
          .brown40,
          .brown50,
          .brown60,
          .asciiBrown,
        ]
        
      case .monochrome:
        [
          .blackTrue,
          .asciiBlack,
          .asciiGrey,
          .asciiWhite,
          .asciiWarmWhite,
          .whiteOff,
          .whiteBone,
          .whiteTrue,
          .grey05,
          .grey10,
          .grey20,
          .grey30,
          .grey40,
          .grey80,
          .grey90,
        ]
        
    }
  }
}

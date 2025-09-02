//
//  Model+.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 3/9/2025.
//

import Foundation

extension HSVColour {
  
  public func contrastColour(
    strength: ModificationStrengthPreset,
    purpose: ColourPurpose = .legibility,
    chroma: ColourChroma = .standard,
  ) -> Self {
    
    guard strength.adjustmentStrength > 0 else { return self }
    
    let adjustment = HSVAdjustment.applyingModifiers(
      for: self,
      strength: strength,
      purpose: purpose,
      chroma: chroma
    )
    
    let adjustedHSV = self.applying(adjustment: adjustment)
    return adjustedHSV
  }
  
  public func contrastColour(modification: ColourModification?) -> RGBColour {
    guard let modification else { return self }
    
    return self.contrastColour(
      strength: modification.strength,
      purpose: modification.purpose,
      chroma: modification.chroma
    )
  }
}

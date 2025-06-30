//
//  ContrastColours.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 29/6/2025.
//

import Foundation

extension RGBColour {

  // MARK: - Main Contrast method
//  private func
//  private func contrastColour(withLuminance luminance: LuminanceLevel) -> RGBColour {
//  private func contrastColour(using adjustment: LuminanceAwareAdjustment) -> RGBColour {
//  }

  // MARK: - Convenient Overloads

  public func contrastColour(
    withPreset preset: ContrastPreset,
    purpose: ContrastPurpose,
    isMonochrome: Bool = false
  ) -> RGBColour {
    
    let hsvColour = HSVColour(fromRGB: self)
    

//    let adjustmentToApply = HSVAdjustment.adjustment(forLumaLevel: self.luminanceLevel, contrastAmount: preset.)
    let adjustmentToApply = preset.adjustment(for: self.luminanceLevel, purpose: purpose)
    
//    let adjustmentToApply = adjustment.adjustment(forLuminance: self.luminance)
    let newHSV: HSVColour = hsvColour.applying(adjustment: adjustmentToApply)
    return RGBColour(fromHSV: newHSV)
//    let lumaAwareAdjustment = LuminanceAwareAdjustment.contrastPreset(preset, isMonochrome: isMonochrome)
    
//    return self.contrastColour(using: lumaAwareAdjustment)
  }
  
//  public static func contrastPreset(
//    _ preset: ContrastPreset,
//    isMonochrome: Bool
//  ) -> Self {
//    return LuminanceAwareAdjustment(
//      light: preset.adjustment(for: .light),
//      dark: preset.adjustment(for: .dark)
//      //      light: preset.level(isMonochrome: isMonochrome).forLightColours,
//      //      dark: preset.level(isMonochrome: isMonochrome).forDarkColours
//    )
//  }

}

public enum ContrastPreset: String, CaseIterable, Identifiable {
  case subtle
  case moderate
  case standard
  case highContrast

  public var id: String { rawValue }

  public var name: String {
    switch self {
      case .subtle: "Subtle"
      case .moderate: "Moderate"
      case .standard: "Standard"
      case .highContrast: "High Contrast"
    }
  }

  private var contrastValue: Double {
    switch self {
      case .subtle: 0.2
      case .moderate: 0.4
      case .standard: 0.75
      case .highContrast: 1.0
    }
  }

  public func adjustment(
    for level: LuminanceLevel,
    purpose: ContrastPurpose
  ) -> HSVAdjustment {
    HSVAdjustment.adjustment(
      forLumaLevel: level,
      contrastAmount: self.contrastValue,
      purpose: purpose
    )
    
//    switch level {
//      case .dark:
//        HSVAdjustment.adjustment(forLumaLevel: <#T##LuminanceLevel#>, contrastAmount: <#T##Double#>)
//      case .mid:
//        <#code#>
//      case .light:
//        <#code#>
//    }
//    switch type {
//      case .light: HSVAdjustment.forLightColours(contrastAmount: self.contrastValue)
//        
//      case .dark: HSVAdjustment.forDarkColours(contrastAmount: self.contrastValue)
//    }
  }
}

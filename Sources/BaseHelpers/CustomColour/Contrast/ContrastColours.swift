//
//  ContrastColours.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 29/6/2025.
//

import Foundation

extension RGBColour {

  // MARK: - Main Contrast method
  private func contrastColour(using adjustment: LuminanceAwareAdjustment) -> RGBColour {
    let hsvColour = HSVColour(fromRGB: self)
    let adjustmentToApply = adjustment.adjustment(forLuminance: self.luminance)
    let newHSV: HSVColour = hsvColour.applying(adjustment: adjustmentToApply)
    return RGBColour(fromHSV: newHSV)
  }

  // MARK: - Convenient Overloads

  public func contrastColour(
    withPreset preset: ContrastPreset,
    isMonochrome: Bool = false
  ) -> RGBColour {
    let lumaAwareAdjustment = LuminanceAwareAdjustment.contrastPreset(preset, isMonochrome: isMonochrome)
    return self.contrastColour(using: lumaAwareAdjustment)
  }
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

  public func adjustment(for type: HSVLuminanceType) -> HSVAdjustment {
    switch type {
      case .light: HSVAdjustment.forLightColours(contrastAmount: self.contrastValue)
      case .dark: HSVAdjustment.forDarkColours(contrastAmount: self.contrastValue)
    }
  }
}

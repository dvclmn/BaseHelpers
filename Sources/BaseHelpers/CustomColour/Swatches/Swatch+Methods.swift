//
//  Swatch+Methods.swift
//  BaseStyles
//
//  Created by Dave Coleman on 29/6/2025.
//

import SwiftUI

extension Swatch {

  public var id: String { rawValue }
  
  public func toRGB(_ environment: EnvironmentValues) -> RGBColour {
    let rgb = RGBColour(colour: self.colour, environment: environment)
    return rgb
  }
//  public func toRGB(
//    _ environment: EnvironmentValues,
//    withPreset preset: ContrastPreset? = nil,
//    purpose: ContrastPurpose = .legibility,
//    isMonochrome: Bool = false
//  ) -> RGBColour {
//    let rgb = RGBColour(colour: self.colour, environment: environment)
//    if let preset {
//      return rgb.contrastColour(
//        withPreset: preset,
//        purpose: purpose,
//        isMonochrome: isMonochrome,
//      )
//    } else {
//      return rgb
//    }
//  }
//  public func toHSV(
//    _ environment: EnvironmentValues,
//    withPreset preset: ContrastPreset? = nil,
//    purpose: ContrastPurpose,
//    isMonochrome: Bool = false
//  ) -> HSVColour {
//    let rgb = self.toRGB(
//      environment,
//      withPreset: preset,
//      purpose: purpose,
//      isMonochrome: isMonochrome
//    )
//    return HSVColour(fromRGB: rgb)
//  }

  public var colour: Color {
    Color("swatch/\(rawValue)", bundle: .module)
  }

  public var name: String {
    guard let number = colourShadeNumber else {
      return rawValue.capitalized
    }
    return self.groupName + String(number) + (isVibrant ? "V" : "")
  }

  public var type: SwatchType {
    switch true {
      case rawValue.hasPrefix("white"): return .shade(.white)
      case rawValue.hasPrefix("black"): return .shade(.black)
      case rawValue.hasPrefix("ascii"): return .ascii
      case rawValue.hasPrefix("neon"): return .neon
      default: return .base
    }
  }

  // MARK: - Grouping
  public var colourShadeNumber: Int? {
    let digits = rawValue.filter { $0.isNumber }
    return Int(digits)
  }
  public var groupName: String {
    switch self.type {
      case .base:
        return rawValue.prefix(while: { $0.isLetter }).lowercased()
      default:
        return self.type.name
    }
  }

  public static func grouped(includesAscii: Bool = false) -> [String: [Self]] {
    let swatches: [Swatch]
    if includesAscii {
      swatches = Self.allCases
    } else {
      swatches = Self.allCases.filter { swatch in
        !swatch.rawValue.contains("ascii")
      }
    }
    let grouped = Dictionary(grouping: swatches) { $0.groupName }
    return grouped
  }
  
  /// May need to revert back to returning an optional, without the default of `red`
  public var primitiveColour: PrimitiveColour {
    return PrimitiveColour.allCases.first(where: { $0.swatches.contains(self) }) ?? .red
  }

  public var isVibrant: Bool {
    return rawValue.hasSuffix("V")
  }

  // MARK: - Older
  public func colour(_ brightnessAdjustment: BrightnessAdjustment, amount: CGFloat) -> some View {
    let newColour = colour.brightness(brightnessAdjustment.adjustment(with: amount))
    return newColour
  }

  public static func swatchesFromIndices(
    _ indices: [Int],
    swatchList: [Swatch]
  ) -> [Swatch] {
    indices.compactMap { index in
      guard index >= 0 && index < swatchList.count else {
        return nil  // Skip invalid indices
      }
      return swatchList[index]
    }
  }

  public static func printSwatchNames(_ list: [Swatch]) -> String {
    let names = list.map { $0.rawValue }
    return names.joined(separator: ", ")
  }

}

extension Array where Element == Swatch {
  public var printSwatchNames: String {
    Swatch.printSwatchNames(self)
  }

  public func swatchesFromIndices(_ indices: [Int]) -> [Swatch] {
    Swatch.swatchesFromIndices(indices, swatchList: self)
  }
}

public enum BrightnessAdjustment {
  case darker
  case brighter

  public func adjustment(with value: CGFloat) -> CGFloat {
    switch self {
      case .darker:
        let result: CGFloat = value * -1
        return min(0, max(1, result))
      case .brighter:
        return min(0, max(1, value))
    }
  }
}

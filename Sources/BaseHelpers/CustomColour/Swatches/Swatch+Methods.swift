//
//  Swatch+Methods.swift
//  BaseStyles
//
//  Created by Dave Coleman on 29/6/2025.
//

import SwiftUI

public enum SwatchShade: String {
  case white
  case black
}

public enum SwatchType {
  case ascii
  case shade(SwatchShade)
  case neon
  case base

  public var name: String {
    switch self {
      case .ascii:
        "ASCII"
      case .shade(let shade):
        shade.rawValue.capitalized
      case .neon:
        "Neon"
      case .base:
        "Base"
    }
  }
}

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

extension Swatch {

  public var primitivecolour: PrimitiveColour? {
    guard let match = PrimitiveColour.allCases.first(where: { $0.swatches.contains(self) }) else {
      return nil
    }
    //      let match = PrimitiveColour.allCases.compactMap { $0.swatches.contains(self) ? self : nil }
    //      let match = PrimitiveColour.allCases.first { $0.swatches.contains(self) }

    return match
    //      return PrimitiveColour.allCases.map(\.swatches)
  }

  //  public var primitiveColourGroup: PrimitiveColour {
  //    switch self {
  //      case .asciiBlack,
  //        .asciiGrey,
  //        .asciiWhite,
  //        .asciiWarmWhite,
  //        .whiteOff,
  //        .whiteBone,
  //        .whiteTrue:
  //        return .monochrome
  //
  //      case .blue50,
  //          .blue
  //
  //    }
  //  }

  public var id: String { rawValue }

  public var colour: Color {
    Color("swatch/\(rawValue)", bundle: .module)
  }

  public var name: String {
    guard let number = colourShadeNumber else {
      return rawValue.capitalized
    }
    return self.groupName + String(number) + (isVibrant ? "V" : "")
  }

  public var isVibrant: Bool {
    return rawValue.hasSuffix("V")
  }

  public var colourShadeNumber: Int? {
    let digits = rawValue.filter { $0.isNumber }
    return digits.isEmpty ? nil : Int(digits)
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

  //  public var colourShadeLabel: String {

  //    guard let numberString = swatch.colourShadeNumber?.toString else { return "" }
  //    return swatch.isVibrant ? numberString + "V" : numberString
  //  }

  public var groupName: String {
    let groupString: String = rawValue.prefix(while: { $0.isLetter }).lowercased()
    switch self.type {
      case .base:
        return groupString
      default:
        return self.type.name
    }
    //    fiefibef
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

  //  public static func swatchesFromIndices(_ indices: [Int], swatchList: [Swatch]) -> [Swatch] {
  //    indices.compactMap { swatchList[$0] }
  //  }

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

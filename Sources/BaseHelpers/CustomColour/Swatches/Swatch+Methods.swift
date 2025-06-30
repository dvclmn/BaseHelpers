//
//  Swatch+Methods.swift
//  BaseStyles
//
//  Created by Dave Coleman on 29/6/2025.
//

import SwiftUI

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

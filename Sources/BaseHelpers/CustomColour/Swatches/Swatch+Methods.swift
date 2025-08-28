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
    let rgb = RGBColour(colour: self.swiftUIColor, environment: environment)
    return rgb
  }

  public var swiftUIColor: Color {
    Color("swatch/\(rawValue)", bundle: .module)
  }

  public var name: String { rawValue }
  //    return "I'm a name"
  //    guard let number = colourShadeNumber else {
  //      return rawValue.capitalized
  //    }
  //    return self.groupName + String(shadeNumber) + (isVibrant ? "V" : "")
  //  }

  public var type: SwatchType { SwatchType(fromRawString: self.rawValue, fallbackType: "Base") }

  public func typeName(fallBackType: String? = nil) -> String {
    return SwatchType(fromRawString: rawValue, fallbackType: fallBackType).name
  }

  // MARK: - Grouping
  public var shadeNumber: String? {
    /// This should return the part of the Swatch case name
    /// that is a number, if present
    let digits = rawValue.filter { $0.isWholeNumber }
    guard !digits.isEmpty else { return nil }
    //    print("Looking for numbers in \(rawValue), found \(digits)")
    return digits
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
    let grouped = Dictionary(grouping: swatches) { $0.typeName() }
    return grouped
  }

  public var primitiveColour: PrimitiveColour? {
    PrimitiveColour(fromSwatch: self)
    //    return PrimitiveColour.allCases.first(where: { $0.swatches.contains(self) }) ?? .red
  }

  public var primitiveColourName: String {
    return primitiveColour?.rawValue ?? "Unknown"
  }

  public var isVibrant: Bool {
    return name.hasSuffix("V")
  }

  //  // MARK: - Older
  //  @available(
  //    *, deprecated,
  //    message:
  //      "Because `brightness` returns `some View`, prefer to use it as it's own modifier in the View. Find alternative way to adjust brightness to return a `Color` instead."
  //  )
  //  public func colour(_ brightnessAdjustment: BrightnessAdjustment, amount: CGFloat) -> some View {
  //    let newColour = swiftUIColor.brightness(brightnessAdjustment.adjustment(with: amount))
  //    return newColour
  //  }
  //
  //  public static func swatchesFromIndices(
  //    _ indices: [Int],
  //    swatchList: [Swatch]
  //  ) -> [Swatch] {
  //    indices.compactMap { index in
  //      guard index >= 0 && index < swatchList.count else {
  //        return nil  // Skip invalid indices
  //      }
  //      return swatchList[index]
  //    }
  //  }

  //  public static func printSwatchNames(_ list: [Swatch]) -> String {
  //    let names = list.map { $0.rawValue }
  //    return names.joined(separator: ", ")
  //  }

}

//extension Array where Element == Swatch {
//  public var printSwatchNames: String {
//    Swatch.printSwatchNames(self)
//  }
//
//  public func swatchesFromIndices(_ indices: [Int]) -> [Swatch] {
//    Swatch.swatchesFromIndices(indices, swatchList: self)
//  }
//}

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

//
//  Font+Config.swift
//  SwiftDown
//
//  Created by Dave Coleman on 26/2/2025.
//

import NSUI

public enum FontDescriptor {
  case system(weight: NSUIFont.Weight, design: NSUIFontDescriptor.SystemDesign)
  case named(String)

  static var `default` = FontDescriptor.system(
    weight: .regular,
    design: .default
  )
}

public struct FontConfig {
  public var size: CGFloat
  public var descriptor: FontDescriptor
  public var traits: NSUIFontDescriptor.SymbolicTraits

  public init(
    descriptor: FontDescriptor,
    size: CGFloat,
    traits: NSUIFontDescriptor.SymbolicTraits = []
  ) {
    self.descriptor = descriptor
    self.size = size
    self.traits = traits
  }

  public mutating func setSize(_ newSize: CGFloat) {
    size = newSize
  }

  public mutating func setWeight(_ newWeight: NSUIFont.Weight) {
    /// Preserve the current descriptor type and other properties
    switch descriptor {
      case .system(_, let design):
        descriptor = .system(weight: newWeight, design: design)

      case .named(let name):
        /// Need to find a better solution for this
        print("Warning: Cannot set weight for named font '\(name)'. Weight changes only apply to system fonts.")
    }
  }

  public static func system(
    size: CGFloat,
    weight: NSUIFont.Weight = .regular,
    design: NSUIFontDescriptor.SystemDesign = .default,
    traits: NSUIFontDescriptor.SymbolicTraits = []
  ) -> Self {
    Self(
      descriptor: .system(weight: weight, design: design),
      size: size,
      traits: traits
    )
  }

  public static func custom(
    name: String,
    size: CGFloat,
    traits: NSUIFontDescriptor.SymbolicTraits = []
  ) -> Self {
    Self(
      descriptor: .named(name),
      size: size,
      traits: traits
    )
  }

  public static func systemBold(
    withSize size: CGFloat
  ) -> Self {
    Self(
      descriptor: .default,
      size: size,
      traits: []
    )
  }
}

extension FontConfig {
  public func resolvedFont() -> NSUIFont? {
    switch descriptor {
      case .system(let weight, let design):
        let baseFont = NSUIFont.systemFont(ofSize: size, weight: weight)
        let descriptor = buildDescriptor(baseFont: baseFont, design: design)
        return NSUIFont(descriptor: descriptor, size: size)

      case .named(let name):
        guard let baseFont = NSUIFont(name: name, size: size) else {
          return nil
        }
        let descriptor = buildDescriptor(baseFont: baseFont)
        return NSUIFont(descriptor: descriptor, size: size)
    }
  }

  private func buildDescriptor(
    baseFont: NSUIFont,
    design: NSUIFontDescriptor.SystemDesign? = nil
  ) -> NSUIFontDescriptor {

    var descriptor = baseFont.fontDescriptor

    if let design, let designDescriptor = descriptor.withDesign(design) {
      descriptor = designDescriptor
    }

    let existingTraits = descriptor.symbolicTraits
    let combinedTraits = existingTraits.union(traits)
    descriptor = descriptor.nsuiWithSymbolicTraits(combinedTraits) ?? NSUIFontDescriptor()
//    descriptor = descriptor.withSymbolicTraits(combinedTraits) ?? NSUIFontDescriptor()
    return descriptor
  }
}



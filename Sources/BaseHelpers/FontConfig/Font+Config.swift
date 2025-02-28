//
//  Font+Config.swift
//  SwiftDown
//
//  Created by Dave Coleman on 26/2/2025.
//

#if os(macOS)

import AppKit

public enum FontDescriptor {
  case system(weight: NSFont.Weight, design: NSFontDescriptor.SystemDesign)
  case named(String)

  static var `default` = FontDescriptor.system(
    weight: .regular,
    design: .default
  )
}

public struct FontConfig {
  public var size: CGFloat
  public var descriptor: FontDescriptor
  public var traits: NSFontDescriptor.SymbolicTraits

  public init(
    descriptor: FontDescriptor,
    size: CGFloat,
    traits: NSFontDescriptor.SymbolicTraits = []
  ) {
    self.descriptor = descriptor
    self.size = size
    self.traits = traits
  }

  public mutating func setSize(_ newSize: CGFloat) {
    size = newSize
  }

  public mutating func setWeight(_ newWeight: NSFont.Weight) {
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
    weight: NSFont.Weight = .regular,
    design: NSFontDescriptor.SystemDesign = .default,
    traits: NSFontDescriptor.SymbolicTraits = []
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
    traits: NSFontDescriptor.SymbolicTraits = []
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
  public func resolvedFont() -> NSFont? {
    switch descriptor {
      case .system(let weight, let design):
        let baseFont = NSFont.systemFont(ofSize: size, weight: weight)
        let descriptor = buildDescriptor(baseFont: baseFont, design: design)
        return NSFont(descriptor: descriptor, size: size)

      case .named(let name):
        guard let baseFont = NSFont(name: name, size: size) else {
          return nil
        }
        let descriptor = buildDescriptor(baseFont: baseFont)
        return NSFont(descriptor: descriptor, size: size)
    }
  }

  private func buildDescriptor(
    baseFont: NSFont,
    design: NSFontDescriptor.SystemDesign? = nil
  ) -> NSFontDescriptor {

    var descriptor = baseFont.fontDescriptor

    if let design, let designDescriptor = descriptor.withDesign(design) {
      descriptor = designDescriptor
    }

    let existingTraits = descriptor.symbolicTraits
    let combinedTraits = existingTraits.union(traits)
    descriptor = descriptor.withSymbolicTraits(combinedTraits)
    return descriptor
  }
}

#endif

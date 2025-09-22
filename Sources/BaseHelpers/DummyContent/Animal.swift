//
//  Categorised.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 21/9/2025.
//

import Foundation

extension DummyContent {
  public struct Animal: Identifiable, Sendable, LabeledItem {
    public let id: UUID
    public let label: QuickLabel
    let state: Bool
    let category: Category

    public init(
      id: UUID = UUID(),
      label: QuickLabel,
      state: Bool,
      category: Category
    ) {
      self.id = UUID()
      self.label = label
      self.state = state
      self.category = category
    }
  }
}

extension DummyContent.Animal {

  public static func withEmojis(fallback: IconLiteral = .emoji("🐾")) -> [Self] {
    return mapWithIcons(iconEmoji, transform: { $0 }, fallback: fallback)
  }

  public static func withSymbols(fallback: IconLiteral = .symbol("pawprint")) -> [Self] {
    return mapWithIcons(iconSymbol, transform: { $0 }, fallback: fallback)
  }

  public static func withCustomSymbols(
    _ customSymbols: [CustomSymbol], fallback: IconLiteral = .customSymbol(.artboard)
  ) -> [Self] {
    return mapWithIcons(customSymbols, transform: { .customSymbol($0) }, fallback: fallback)
  }

  public static let data = [
    Self(label: "Giraffe", state: true, category: Category.cute),
    Self(label: "Tapir", state: false, category: Category.predator),
    Self(label: "Dog", state: true, category: Category.endangered),
    Self(label: "Cat", state: false, category: Category.cute),
    Self(label: "Orangutan", state: false, category: Category.extinct),
    Self(label: "Bearded Dragon", state: false, category: Category.predator),
    Self(label: "Goat", state: false, category: Category.cute),
    Self(label: "Ibis", state: true, category: Category.extinct),
    Self(label: "Zebra", state: false, category: Category.endangered),
  ]

  static let iconSymbol: [IconLiteral] = [
    .symbol(Icons.binoculars.icon),
    .symbol(Icons.window.icon),
    .symbol(Icons.star.icon),
    .symbol(Icons.folder.icon),
    .symbol(Icons.trophy.icon),
    .symbol(Icons.trash.icon),
    .symbol(Icons.bookmark.icon),
    .symbol(Icons.rpg.icon),
    .symbol(Icons.rotate.icon),
  ]

  static let iconEmoji: [IconLiteral] = [
    .emoji("🐶"),
    .emoji("🐱"),
    .emoji("🐭"),
    .emoji("🐹"),
    .emoji("🐰"),
    .emoji("🦎"),
    .emoji("🦖"),
    .emoji("🦗"),
    .emoji("🦘"),
  ]
}

/// Generic helper method compatible with QuickLabel structure
extension DummyContent.Animal {
  static func mapWithIcons<T>(
    _ icons: [T],
    transform: (T) -> IconLiteral,
    fallback: IconLiteral
  ) -> [Self] {
    return Self.data.enumerated().map { index, animal in
      let iconIndex = index < icons.count ? index : index % max(icons.count, 1)
      let newIcon = icons.isEmpty ? fallback : transform(icons[iconIndex])

      /// Create new QuickLabel with the original attributedText and role, but new icon
      let newLabel = QuickLabel(
        attributedText: animal.label.attributedText,
        icon: newIcon,
        role: animal.label.role
      )

      return Self(
        id: animal.id,
        label: newLabel,
        state: animal.state,
        category: animal.category
      )
    }
  }

}

//extension DummyContent.Animal {
//  static func mapWithIcons(
//    _ icons: [IconLiteral],
//    transform: (IconLiteral) -> IconLiteral,
//    fallback: IconLiteral
//  ) -> [Self] {
//    return Self.data.enumerated().map { index, animal in
//      let iconIndex = index < icons.count ? index : index % max(icons.count, 1)
//      let newIcon = icons.isEmpty ? fallback : transform(icons[iconIndex])
//
//      let newLabel = QuickLabel(animal.label.text, icon: newIcon)
//
//      return Self(
//        id: animal.id,
//        label: newLabel,
//        state: animal.state,
//        category: animal.category
//      )
//    }
//  }
//
//  // Usage examples:
//  // static let customEmojiData = mapWithIcons(iconEmoji, transform: { $0 }, fallback: .emoji("🐾"))
//  // static let customSymbolData = mapWithIcons(iconSymbol, transform: { $0 }, fallback: .symbol(Icons.pawprint.icon))
//}

extension DummyContent.Animal {
  public enum Category: String, ModelBase {
    case predator
    case cute
    case extinct
    case endangered

    var name: String {
      self.rawValue.capitalized
    }

    var icon: String {
      switch self {
        case .predator: Icons.binoculars.icon
        case .cute: Icons.window.icon
        case .extinct: Icons.star.icon
        case .endangered: Icons.folder.icon
      }
    }
  }
}

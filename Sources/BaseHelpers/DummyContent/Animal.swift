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
      _ label: QuickLabel,
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

  public static let data = [
    Self("Giraffe", state: true, category: Category.cute),
    Self("Tapir", state: false, category: Category.predator),
    Self("Dog", state: true, category: Category.endangered),
    Self("Cat", state: false, category: Category.cute),
    Self("Orangutan", state: false, category: Category.extinct),
    Self("Bearded Dragon", state: false, category: Category.predator),
    Self("Goat", state: false, category: Category.cute),
    Self("Ibis", state: true, category: Category.extinct),
    Self("Zebra", state: false, category: Category.endangered),
    //    Self(QuickLabel("Giraffe", icon: .emoji("🐶")), state: true, category: Category.cute),
    //    Self(QuickLabel("Tapir", icon: .emoji("🐶")), state: false, category: Category.predator),
    //    Self(QuickLabel("Dog", icon: .emoji("🐶")), state: true, category: Category.endangered),
    //    Self(QuickLabel("Cat", icon: .emoji("🐶")), state: false, category: Category.cute),
    //    Self(QuickLabel("Orangutan", icon: .emoji("🐶")), state: false, category: Category.extinct),
    //    Self(QuickLabel("Bearded Dragon", icon: .emoji("🐶")), state: false, category: Category.predator),
    //    Self(QuickLabel("Goat", icon: .emoji("🐶")), state: false, category: Category.cute),
    //    Self(QuickLabel("Ibis", icon: .emoji("🐶")), state: true, category: Category.extinct),
    //    Self(QuickLabel("Zebra", icon: .emoji("🐶")), state: false, category: Category.endangered),
  ]

  public static let iconSymbol: [IconLiteral] = [
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
    //    .emoji("🦙"),
  ]
}

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

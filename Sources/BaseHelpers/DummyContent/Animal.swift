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
    let category: AnimalCategory

    public init(
      _ label: String,
      state: Bool,
      category: AnimalCategory
    ) {
      self.id = UUID()
      self.label = QuickLabel(label)
      self.state = state
      self.category = category
    }

    public static let data = [
      Self("Giraffe", state: true, category: AnimalCategory.cute),
      Self("Tapir", state: false, category: AnimalCategory.predator),
      Self("Dog", state: true, category: AnimalCategory.endangered),
      Self("Cat", state: false, category: AnimalCategory.cute),
      Self("Orangutan", state: false, category: AnimalCategory.extinct),
      Self("Bearded Dragon", state: false, category: AnimalCategory.predator),
      Self("Goat", state: false, category: AnimalCategory.cute),
      Self("Ibis", state: true, category: AnimalCategory.extinct),
      Self("Zebra", state: false, category: AnimalCategory.endangered),
    ]
  }
  public enum AnimalCategory: String, ModelBase {
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

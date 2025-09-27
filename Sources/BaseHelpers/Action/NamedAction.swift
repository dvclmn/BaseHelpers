//
//  Action.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 27/9/2025.
//

import Foundation

public protocol NamedAction: LabeledItem {
  /// e.g. "Delete", "Mark Favourite"
  var verb: String { get }
  var icon: String? { get }

  /// Singular noun for the item, e.g. "Game"
  static var itemName: String { get }

  /// Optional override for plural, e.g. "People" instead of "Persons"
  static var itemPluralName: String? { get }
}

extension NamedAction {

  public var label: QuickLabel {
    QuickLabel(
      verb,
      icon: .symbol(<#T##String#>),
      role: <#T##QuickLabel.Role?#>
    )
  }

  public static var itemPluralName: String? { nil }

  /// Example usage:
  /// ```
  /// let affectedCount = ContextSelection(
  ///   clickedID: clickedID,
  ///   selectedIDs: selectedIDs
  /// ).affectedIDs().count
  ///
  /// let label = Action.delete.buttonLabel(
  ///   count: affectedCount
  /// )
  /// ```
  ///
  /// Text label for a button
  /// - Parameters:
  ///   - count: Number of items involved
  ///   - countStrategy: Options for handling nuances of count
  /// - Returns: Text label
  public func actionName(
    count: Int,
    countStrategy: CountStrategy = .showCount(always: false)
  ) -> String {
    let noun = Self.itemName
    let pluralOverride = Self.itemPluralName
    let nounPart = pluralise(noun, count: count, countStrategy: countStrategy, irregularPlural: pluralOverride)
    return "\(verb) \(nounPart)"
  }
}

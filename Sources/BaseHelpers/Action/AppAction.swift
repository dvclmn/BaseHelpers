//
//  Action.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 27/9/2025.
//

import Foundation

public protocol AppAction: Hashable {
  /// e.g. "Delete", "Mark Favourite"
  var verb: String { get }
  
  /// Singular noun for the item, e.g. "Game"
  static var itemName: String { get }
  
  /// Optional override for plural, e.g. "People" instead of "Persons"
  static var itemPluralName: String? { get }
}

extension AppAction {
  
  public static var itemPluralName: String? { nil }
  
  /// Example usage:
  /// ```
  /// let affectedCount = ContextSelection(
  ///   clickedID: clickedID,
  ///   selectedIDs: selectedIDs
  /// ).affectedIDs().count
  ///
  /// let label = EucalyptAction.delete.buttonLabel(
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

//public enum UndoStrategy<T: AppAction> {
//  case registerUndo(action: T)
//  case none
//}

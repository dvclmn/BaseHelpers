//
//  LabeledItem.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 26/5/2025.
//

import Foundation

public protocol LabeledItem: ModelBaseWithID {
  var id: String { get }
  var label: QuickLabel { get }
  var blurb: String? { get }
}

extension LabeledItem {
  public var id: String { self.label.text }
  public var blurb: String? { nil }
}

extension LabeledItem where Self: RawRepresentable, Self.RawValue == String {
  public var label: QuickLabel { .init(rawValue.capitalized) }
  public var name: String { rawValue.capitalized }
}

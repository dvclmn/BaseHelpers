//
//  LabeledEnum.swift
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

public protocol LabeledEnum<Item>: CaseIterable, RawRepresentable
where Self.AllCases: RandomAccessCollection, RawValue == String {
  associatedtype Item: LabeledItem
  //  var id: String { get }
  //  var label: QuickLabel { get }
  //  var blurb: String? { get }
}

extension LabeledEnum {

  

  /// Convenient default value for name and label,
  /// derived from raw value
  public var label: QuickLabel {
    let title = self.rawValue.capitalized
    return QuickLabel(title)
  }
  public var name: String {
    return self.rawValue.capitalized
  }
}

//public protocol LabeledItem: Equatable, Identifiable, Sendable, RawRepresentable, Hashable
//where Self.RawValue == String {
//
//  var id: String { get }
//  var label: QuickLabel { get }
//  var blurb: String? { get }
//}
//
//extension LabeledItem {
//
//  public var blurb: String? { nil }
//  public var id: String { self.rawValue }
//
//  /// Convenient default value for name and label,
//  /// derived from raw value
//  public var label: QuickLabel {
//    let title = self.rawValue.capitalized
//    return QuickLabel(title)
//  }
//
//  public var name: String {
//    return self.rawValue.capitalized
//  }
//}

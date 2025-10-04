//
//  Model+DisplayPair.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 10/7/2025.
//

import AssociatedValues
import Foundation

/// A property label is aimed at expressing the
/// string representaiton for a property, such as
/// "X" and "Y" properties for CGPoint. Or "width"
/// and "height" for CGSize.
///
/// With the option for a default version and a short version.
/// E.g. default: "width", abbreviated: "W"
public struct PropertyLabel {

  /// The standard / more verbose representation,
  /// e.g. `Width` for `CGSize`
  let label: String

  /// A more concise version, such as `W` instead of `Width`
  let abbreviated: String

  public init(_ label: String, abbreviated: String? = nil) {
    self.label = label
    self.abbreviated = abbreviated ?? label
  }

  public init(_ label: String, _ abbreviated: String) {
    self.label = label
    self.abbreviated = abbreviated
  }
}

extension PropertyLabel: ExpressibleByStringLiteral {
  public init(stringLiteral value: String) {
    self.init(value)
  }
}

extension PropertyLabel {
  //@AssociatedValues
  public enum Style: Equatable {
    case none
    case standard
    case abbreviated
    //  case standard(String)
    //  case abbreviated(String)

    public var keyPath: KeyPath<PropertyLabel, String>? {
      switch self {
        case .none: nil
        case .standard: \.label
        case .abbreviated: \.abbreviated
      }
    }

    //    public var label: String? {
    //      switch self {
    //        case .none: nil
    //        case .standard(let string): string
    //        case .abbreviated(let string): string
    //      }
    //    }
    /// This will be composed together with float values
    /// within `DisplayString/formatted()`.
    /// Returning nil allows expressing "No label please"
    public func labelString(
      for label: PropertyLabel
        //        for component: Component
    ) -> String? {

      guard let keyPath else { return nil }
      return label[keyPath: keyPath]
    }
  }
}

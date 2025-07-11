//
//  Model+GridDimension.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 3/7/2025.
//

import SwiftUI

public enum GridAxis: GridBase {
  case horizontal
  case vertical

  var locationKeyPath: WritableKeyPath<CGPoint, CGFloat> {
    switch self {
      case .horizontal: return \.x
      case .vertical: return \.y
    }
  }

  var sizeKeyPath: KeyPath<CGSize, CGFloat> {
    switch self {
      case .horizontal: return \.width
      case .vertical: return \.height
    }
  }

  var opposing: Self {
    switch self {
      case .horizontal: return .vertical
      case .vertical: return .horizontal
    }
  }

  /// The 'actual' value, for the corresponding property, from the `GridCanvas` itself
  public var dimensionsKeyPath: WritableKeyPath<GridDimensions, Int> {
    switch self {
      case .horizontal: \.columns
      case .vertical: \.rows
    }
  }

  public var positionKeyPath: KeyPath<GridPosition, Int> {
    switch self {
      case .horizontal: \.column
      case .vertical: \.row
    }
  }
}

/// Metadata
extension GridAxis {

  public var name: String {
    switch self {
      case .horizontal: "Width"
      case .vertical: "Height"
    }
  }

  public var icon: String {
    switch self {
      case .horizontal:
        "arrow.left.and.right.text.vertical"
      //          "rectangle.portrait.arrowtriangle.2.outward"

      case .vertical:
        "arrow.up.and.down.text.horizontal"
    //          "rectangle.arrowtriangle.2.outward"
    }
  }

  public var altName: String {
    switch self {
      case .horizontal: "Columns"
      case .vertical: "Rows"
    }
  }

  public var altName02: String {
    switch self {
      case .horizontal: "Horizontal"
      case .vertical: "Vertical"
    }
  }
}

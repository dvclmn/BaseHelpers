//
//  Model+GridDimension.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 3/7/2025.
//

import SwiftUI

public protocol AxisAware {
  var row: Int { get }
  var column: Int { get }
}

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
//  var dimensionKey: WritableKeyPath<GridCanvas.Dimensions, Int> {
//    switch self {
//      case .horizontal: \.columns
//      case .vertical: \.rows
//    }
//  }
//  /// Returns the key path for the opposite dimension
//  var opposingDimensionKey: KeyPath<GridCanvas.Dimensions, Int> {
//    switch self {
//      case .horizontal: \.rows
//      case .vertical: \.columns
//    }
//  }

//  var gridPositionKey: KeyPath<GridPosition, Int> {
//    switch self {
//      case .horizontal: \.column
//      case .vertical: \.row
//    }
//  }

  //    var artworkPositionKey: KeyPath<ArtworkPosition, Int> {
  //      switch self {
  //        case .horizontal: \.col
  //        case .vertical: \.row
  //      }
  //    }

  //    var cellPositionKey: KeyPath<GridCanvas.CellPosition, Int> {
  //      switch self {
  //        case .horizontal: \.col
  //        case .vertical: \.row
  //      }
  //    }

}

//extension CGPoint {
//  func getValue(in dimension: GridCanvas.Dimension) -> CGFloat {
//    self[keyPath: dimension.locationKeyPath]
//  }
//
//  mutating func setValue(_ value: CGFloat, in dimension: GridCanvas.Dimension) {
//    self[keyPath: dimension.locationKeyPath] = value
//  }
//}
//
//extension CGSize {
//  func getValue(in dimension: GridCanvas.Dimension) -> CGFloat {
//    self[keyPath: dimension.sizeKeyPath]
//  }
//}

/// Metadata
extension GridAxis {
  
  var name: String {
    switch self {
      case .horizontal: "Width"
      case .vertical: "Height"
    }
  }
  
  var icon: String {
    switch self {
      case .horizontal:
        "arrow.left.and.right.text.vertical"
        //          "rectangle.portrait.arrowtriangle.2.outward"
        
      case .vertical:
        "arrow.up.and.down.text.horizontal"
        //          "rectangle.arrowtriangle.2.outward"
    }
  }
  
  var altName: String {
    switch self {
      case .horizontal: "Columns"
      case .vertical: "Rows"
    }
  }
  
  var altName02: String {
    switch self {
      case .horizontal: "Horizontal"
      case .vertical: "Vertical"
    }
  }
}

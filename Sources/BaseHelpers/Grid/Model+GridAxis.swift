//
//  Model+GridDimension.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 3/7/2025.
//

import SwiftUI

//public protocol Dimensionable {
//  var row: Int { get }
//  var column: Int { get }
//}

public enum GridAxis {
  case row
  case column

  var locationKeyPath: WritableKeyPath<CGPoint, CGFloat> {
    switch self {
      case .row: return \.x
      case .column: return \.y
    }
  }

  var sizeKeyPath: KeyPath<CGSize, CGFloat> {
    switch self {
      case .row: return \.width
      case .column: return \.height
    }
  }
  
  var opposing: GridDimension {
    switch self {
      case .row: return .column
      case .column: return .row
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
extension GridDimension {
  var name: String {
    switch self {
      case .row: "Width"
      case .column: "Height"
    }
  }
  
  var icon: String {
    switch self {
      case .row:
        "arrow.left.and.right.text.vertical"
        //          "rectangle.portrait.arrowtriangle.2.outward"
        
      case .column:
        "arrow.up.and.down.text.horizontal"
        //          "rectangle.arrowtriangle.2.outward"
    }
  }
  
  var altName: String {
    switch self {
      case .row: "Columns"
      case .column: "Rows"
    }
  }
  
  var altName02: String {
    switch self {
      case .row: "Horizontal"
      case .column: "Vertical"
    }
  }
}

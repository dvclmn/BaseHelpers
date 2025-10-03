//
//  Model+GridDimension.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 3/7/2025.
//

import SwiftUI

/// Note: `GridAxis` is about how indices progress across the grid,
/// not about how the things themselves are shaped.
///
/// Even though a column is (in isolation) a 'vertical thing'.
///
/// ```
///  x →   column 0   column 1   column 2
///       ┌───┬───┬───┐
///  y ↓  │   │   │   │   row 0
///       ├───┼───┼───┤
///       │   │   │   │   row 1
///       ├───┼───┼───┤
///       │   │   │   │   row 2
///
/// ```
public enum GridAxis: String, ModelBase, CaseIterable, Identifiable {
  /// Horizontal
  case column

  /// Vertical
  case row

  public static let fixedLength: CGFloat = 18

  public var id: String { rawValue }

  public var locationKeyPath: WritableKeyPath<CGPoint, CGFloat> {
    switch self {
      case .column: return \.x
      case .row: return \.y
    }
  }

  public var sizeKeyPath: KeyPath<CGSize, CGFloat> {
    switch self {
      case .column: return \.width
      case .row: return \.height
    }
  }

  public var opposing: Self {
    switch self {
      case .column: return .row
      case .row: return .column
    }
  }

  /// The 'actual' value, for the corresponding property, from the `GridCanvas` itself
  public var dimensionsKeyPath: WritableKeyPath<GridDimensions, Int> {
    switch self {
      case .column: \.columns
      case .row: \.rows
    }
  }

  public var positionKeyPath: KeyPath<GridPosition, Int> {
    switch self {
      case .column: \.column
      case .row: \.row
    }
  }

  public var numberingFrameSize: (CGFloat?, CGFloat?) {

    return switch self {
      case .column: (nil, Self.fixedLength)
      case .row: (Self.fixedLength, nil)
    }
  }

  public var cellNumberTextAlignment: UnitPoint {
    switch self {
      case .column: .center
      case .row: .trailing
    }
  }

  public var numberingShapeAlignment: Alignment {
    switch self {
      case .column: .top
      case .row: .leading
    }
  }

  public func cellNumberPositioning(
    _ cellIndex: Int,
    cellSize: CGSize
  ) -> CGPoint {
    switch self {
      case .column:
        CGPoint(
          x: CGFloat(cellIndex - 1) * cellSize.width,
          y: 0  // Columns align along the Y axis
        )

      case .row:
        CGPoint(
          x: 0,  // Rows align down the X axis
          y: CGFloat(cellIndex - 1) * cellSize.height
        )
    }
  }

  public func axisOffset(
    frameInViewport frame: CGRect,
  ) -> CGSize {
    return switch self {
      case .column:
        CGSize(
          width: frame.origin.x,
          height: 0
        )
      case .row:
        CGSize(
          /// Width is zero as I don't want to decouple
          width: 0,
          height: frame.origin.y
        )

    }
  }

  public func hasOverflow(
    canvasFrameInViewport: CGRect?,
    buffer: CGFloat,
  ) -> Bool {

    guard let canvasFrameInViewport else { return false }
    switch self {
      case .column:
        let minX = canvasFrameInViewport.minX - buffer
        let hasOverflow: Bool = minX < 0
        return hasOverflow

      case .row:
        let minY = canvasFrameInViewport.minY - buffer
        let hasOverflow: Bool = minY < 0
        return hasOverflow
    }
  }

}

/// Metadata
extension GridAxis {

  public var name: String {
    switch self {
      case .column: "Width"
      case .row: "Height"
    }
  }

  public var icon: String {
    switch self {
      case .column:
        "arrow.left.and.right.text.vertical"
      //          "rectangle.portrait.arrowtriangle.2.outward"

      case .row:
        "arrow.up.and.down.text.horizontal"
    //          "rectangle.arrowtriangle.2.outward"
    }
  }

  public var altName: String {
    switch self {
      case .column: "Columns"
      case .row: "Rows"
    }
  }

  public var altName02: String {
    switch self {
      case .column: "Horizontal"
      case .row: "Vertical"
    }
  }
}

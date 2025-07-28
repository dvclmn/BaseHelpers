//
//  Model+GridDimension.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 3/7/2025.
//

import SwiftUI

public enum GridAxis: String, GridBase, CaseIterable, Identifiable {
  /// Horizontal
  case columns

  /// Vertical
  case rows

  public static let fixedLength: CGFloat = 18

  public var id: String { rawValue }

  public var locationKeyPath: WritableKeyPath<CGPoint, CGFloat> {
    switch self {
      case .columns: return \.x
      case .rows: return \.y
    }
  }

  public var sizeKeyPath: KeyPath<CGSize, CGFloat> {
    switch self {
      case .columns: return \.width
      case .rows: return \.height
    }
  }

  public var opposing: Self {
    switch self {
      case .columns: return .rows
      case .rows: return .columns
    }
  }

  /// The 'actual' value, for the corresponding property, from the `GridCanvas` itself
  public var dimensionsKeyPath: WritableKeyPath<GridDimensions, Int> {
    switch self {
      case .columns: \.columns
      case .rows: \.rows
    }
  }

  public var positionKeyPath: KeyPath<GridPosition, Int> {
    switch self {
      case .columns: \.column
      case .rows: \.row
    }
  }

  public var numberingFrameSize: (CGFloat?, CGFloat?) {

    return switch self {
      case .columns: (nil, Self.fixedLength)
      case .rows: (Self.fixedLength, nil)
    }
  }

  public var cellNumberTextAlignment: UnitPoint {
    switch self {
      case .columns: .center
      case .rows: .trailing
    }
  }

  public var numberingShapeAlignment: Alignment {
    switch self {
      case .columns: .top
      case .rows: .leading
    }
  }

  public func cellNumberSpacing(
    _ cellIndex: Int,
    cellSize: CGSize
  ) -> CGPoint {
    switch self {
      case .columns:
        CGPoint(
          x: CGFloat(cellIndex - 1) * cellSize.width,
          y: 0  // Columns align along the Y axis
        )

      case .rows:
        CGPoint(
          x: 0,  // Rows align down the X axis
          y: CGFloat(cellIndex - 1) * cellSize.height
        )
    }
  }

  public func axisOffset(
    canvasFrameInViewport: CGRect?,
  ) -> CGSize {
    guard let frame = canvasFrameInViewport else { return .zero }
    return switch self {
      case .columns:
        CGSize(
          width: frame.origin.x,
          height: 0
        )
      case .rows:
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
      case .columns:
        let minX = canvasFrameInViewport.minX - buffer
        let hasOverflow: Bool = minX < 0
        return hasOverflow

      case .rows:
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
      case .columns: "Width"
      case .rows: "Height"
    }
  }

  public var icon: String {
    switch self {
      case .columns:
        "arrow.left.and.right.text.vertical"
      //          "rectangle.portrait.arrowtriangle.2.outward"

      case .rows:
        "arrow.up.and.down.text.horizontal"
    //          "rectangle.arrowtriangle.2.outward"
    }
  }

  public var altName: String {
    switch self {
      case .columns: "Columns"
      case .rows: "Rows"
    }
  }

  public var altName02: String {
    switch self {
      case .columns: "Horizontal"
      case .rows: "Vertical"
    }
  }
}

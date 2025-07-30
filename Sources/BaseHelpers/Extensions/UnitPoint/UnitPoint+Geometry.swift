//
//  UnitPoint+Geometry.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 30/7/2025.
//

import SwiftUI

extension UnitPoint {

  public var isCorner: Bool {
    switch self {
      case .topLeading, .topTrailing, .bottomTrailing, .bottomLeading: true
      default: false
    }
  }

  public var isHorizontalEdge: Bool {
    switch self {
      case .top, .bottom: true
      default: false
    }
  }

  public var isVerticalEdge: Bool {
    switch self {
      case .leading, .trailing: true
      default: false
    }
  }

  /// A collection of unit points arranged horizontally along the top edge.
  ///
  /// This property provides the three unit points that form the top row of a rectangular layout.
  ///
  /// ## Usage
  ///
  /// Use this property when you need to work with all points along the top edge, such as for animations
  /// or applying consistent styling to top-aligned elements.
  ///
  /// ```swift
  /// for point in UnitPoint.rowTop {
  ///     // Apply animation to each top point
  ///     animateView(to: point)
  /// }
  /// ```
  ///
  /// ## Visual Layout
  ///
  /// ```
  /// ●───●───●
  /// │   │   │
  /// │   │   │
  /// ```
  ///
  /// - Returns: An array containing the three unit points along the top edge.
  public static var rowTop: [UnitPoint] {
    [
      .topLeading,
      .top,
      .topTrailing,
    ]
  }

  /// A collection of unit points arranged horizontally along the vertical center.
  ///
  /// This property provides the three unit points that form the middle row of a rectangular layout.
  ///
  /// ## Usage
  ///
  /// Use this property when you need to work with all points along the vertical center line,
  /// perfect for center-based animations or layouts.
  ///
  /// ```swift
  /// let centerPoints = UnitPoint.rowMiddle
  /// // Apply effects to horizontally centered points
  /// ```
  ///
  /// ## Visual Layout
  ///
  /// ```
  /// │   │   │
  /// ●───●───●
  /// │   │   │
  /// ```
  ///
  /// - Returns: An array containing the three unit points along the vertical center.
  public static var rowMiddle: [UnitPoint] {
    [
      .leading,
      .center,
      .trailing,
    ]
  }

  /// A collection of unit points arranged horizontally along the bottom edge.
  ///
  /// This property provides the three unit points that form the bottom row of a rectangular layout.
  ///
  /// ## Usage
  ///
  /// Use this property when you need to work with all points along the bottom edge, such as for
  /// bottom-anchored animations or consistent bottom alignment.
  ///
  /// ```swift
  /// UnitPoint.rowBottom.forEach { point in
  ///     view.anchor(to: point)
  /// }
  /// ```
  ///
  /// ## Visual Layout
  ///
  /// ```
  /// │   │   │
  /// │   │   │
  /// ●───●───●
  /// ```
  ///
  /// - Returns: An array containing the three unit points along the bottom edge.
  public static var rowBottom: [UnitPoint] {
    [
      .bottomLeading,
      .bottom,
      .bottomTrailing,
    ]
  }

  /// A collection of unit points arranged vertically along the leading edge.
  ///
  /// This property provides the three unit points that form the leading column of a rectangular layout.
  ///
  /// ## Usage
  ///
  /// Use this property when you need to work with all points along the leading edge. In left-to-right
  /// languages, this represents the left side of the layout.
  ///
  /// ```swift
  /// for point in UnitPoint.columnLeading {
  ///     // Position elements along the leading edge
  ///     positionElement(at: point)
  /// }
  /// ```
  ///
  /// ## Visual Layout
  ///
  /// ```
  /// ●   │   │
  /// │   │   │
  /// ●   │   │
  /// │   │   │
  /// ●   │   │
  /// ```
  ///
  /// - Returns: An array containing the three unit points along the leading edge.
  public static var columnLeading: [UnitPoint] {
    [
      .topLeading,
      .leading,
      .bottomLeading,
    ]
  }

  /// A collection of unit points arranged vertically along the horizontal center.
  ///
  /// This property provides the three unit points that form the middle column of a rectangular layout.
  ///
  /// ## Usage
  ///
  /// Use this property when you need to work with all points along the horizontal center line,
  /// ideal for center-aligned layouts and animations.
  ///
  /// ```swift
  /// let centerColumn = UnitPoint.columnMiddle
  /// // Create vertical center-based transitions
  /// ```
  ///
  /// ## Visual Layout
  ///
  /// ```
  /// │   ●   │
  /// │   │   │
  /// │   ●   │
  /// │   │   │
  /// │   ●   │
  /// ```
  ///
  /// - Returns: An array containing the three unit points along the horizontal center.
  public static var columnMiddle: [UnitPoint] {
    [
      .top,
      .center,
      .bottom,
    ]
  }

  /// A collection of unit points arranged vertically along the trailing edge.
  ///
  /// This property provides the three unit points that form the trailing column of a rectangular layout
  ///
  /// ## Usage
  ///
  /// Use this property when you need to work with all points along the trailing edge. In left-to-right
  /// languages, this represents the right side of the layout.
  ///
  /// ```swift
  /// UnitPoint.columnTrailing.enumerated().forEach { index, point in
  ///     animateWithDelay(point, delay: TimeInterval(index) * 0.1)
  /// }
  /// ```
  ///
  /// ## Visual Layout
  ///
  /// ```
  /// │   │   ●
  /// │   │   │
  /// │   │   ●
  /// │   │   │
  /// │   │   ●
  /// ```
  ///
  /// - Returns: An array containing the three unit points along the trailing edge.
  public static var columnTrailing: [UnitPoint] {
    [
      .topTrailing,
      .trailing,
      .bottomTrailing,
    ]
  }
}

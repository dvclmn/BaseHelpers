//
//  Axis.swift
//  Collection
//
//  Created by Dave Coleman on 30/10/2024.
//

import SwiftUI

public extension Axis {
  /// Returns either the width or height of a CGSize based on the axis.
  /// - Parameter size: The CGSize to extract the dimension from
  /// - Returns: The appropriate dimension (width for vertical, height for horizontal)
  func dimension(from size: CGSize) -> CGFloat {
    switch self {
      case .horizontal:
        return size.height
      case .vertical:
        return size.width
    }
  }

  /// Returns either the width or height of a CGSize based on the perpendicular axis.
  /// - Parameter size: The CGSize to extract the dimension from
  /// - Returns: The perpendicular dimension (width for horizontal, height for vertical)
  func perpendicularDimension(from size: CGSize) -> CGFloat {
    switch self {
      case .horizontal:
        return size.width
      case .vertical:
        return size.height
    }
  }

}

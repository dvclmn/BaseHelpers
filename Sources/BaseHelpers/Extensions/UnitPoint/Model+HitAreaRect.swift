//
//  Model+HitAreaRect.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 1/8/2025.
//

import SwiftUI

public struct HitAreaLayout {
  let anchor: UnitPoint
  let thickness: CGFloat
  let offset: RectBoundaryPlacement
  let shouldIncludeCorners: Bool

  var fillDirection: Axis {
    anchor.toAxis ?? .vertical
  }

  public init(
    anchor: UnitPoint,
    thickness: CGFloat,
    offset: RectBoundaryPlacement,
    shouldIncludeCorners: Bool,
  ) {
    self.anchor = anchor
    self.thickness = thickness
    self.offset = offset
    self.shouldIncludeCorners = shouldIncludeCorners
  }
}

extension HitAreaLayout {

  public var alignment: Alignment {
    anchor.toAlignment
  }

  public var fillSize: CGSize {
    switch anchor.pointType {
      case .horizontalEdge:
        return CGSize(width: .infinity, height: thickness)
      case .verticalEdge:
        return CGSize(width: thickness, height: .infinity)
      case .corner:
        return shouldIncludeCorners ? CGSize(fromLength: thickness) : .zero
      case .centre:
        return .zero

    }
  }

  /// Padding created to accomodate corners if present
  public var edgePadding: EdgeInsets {

    let inset = thickness

    let padding: EdgeInsets =
      switch (offset, shouldIncludeCorners) {
        case (.outside, _): .zero
        case (_, false): .zero
        case (.inside, true): anchor.hitAreaPadding(inset)
        case (.centre, true): anchor.hitAreaPadding(inset / 2)

      }

    return padding
  }

  public var rectOffset: CGSize {

    let offsetAmount: CGFloat =
      switch offset {
        case .inside: .zero
        case .outside: -thickness
        case .centre: -thickness / 2
      }
    return anchor.offset(by: offsetAmount)
  }
}

extension UnitPoint {
  func hitAreaPadding(_ amount: CGFloat) -> EdgeInsets {
    switch self {
      case .top, .bottom:
        return EdgeInsets(leading: amount, trailing: amount)

      case .leading, .trailing:
        return EdgeInsets(top: amount, bottom: amount)

      default:
        return .zero
    }
  }
}

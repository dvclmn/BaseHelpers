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
  let shouldIncludeCorners: Bool

  public var fillDirection: Axis {
    anchor.toAxis ?? .vertical
  }

  public init(
    anchor: UnitPoint,
    thickness: CGFloat,
    shouldIncludeCorners: Bool,
  ) {
    self.anchor = anchor
    self.thickness = thickness
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

  public var edgePadding: EdgeInsets {
    guard shouldIncludeCorners else { return .zero }
    let inset = thickness
    switch anchor {
      case .top:
        return EdgeInsets(leading: inset, trailing: inset)
      case .bottom:
        return EdgeInsets(leading: inset, trailing: inset)
      case .leading:
        return EdgeInsets(top: inset, bottom: inset)
      case .trailing:
        return EdgeInsets(top: inset, bottom: inset)
      default:
        return .zero
    }
  }
}
extension EdgeInsets {
  static var zero: EdgeInsets {
    EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
  }

  init(top: CGFloat = 0, leading: CGFloat = 0, bottom: CGFloat = 0, trailing: CGFloat = 0) {
    self.init()
    self.top = top
    self.leading = leading
    self.bottom = bottom
    self.trailing = trailing
  }
}

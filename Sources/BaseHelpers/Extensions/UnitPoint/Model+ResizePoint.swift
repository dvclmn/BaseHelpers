//
//  Model+ResizePoint.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 6/8/2025.
//

import SwiftUI

public enum ResizePoint: String, CaseIterable, Identifiable {
  case topLeading
  case topTrailing
  case bottomLeading
  case bottomTrailing

  case top
  case trailing
  case leading
  case bottom

}

extension ResizePoint {

  public init(fromUnitPoint unitPoint: UnitPoint) {
    self =
      switch unitPoint {
        case .topLeading: .topLeading
        case .topTrailing: .topTrailing
        case .bottomLeading: .bottomLeading
        case .bottomTrailing: .bottomTrailing

        case .top: .top
        case .trailing: .trailing
        case .leading: .leading
        case .bottom: .bottom

        default: fatalError("Unsupported unit point: \(unitPoint)")
      }
  }

  public var id: String { rawValue }

  public var toAlignment: Alignment {
    toUnitPoint.toAlignment
  }

  public var toLayoutAxis: Axis? {
    if toUnitPoint.isHorizontalEdge {
      return .horizontal
    } else if toUnitPoint.isVerticalEdge {
      return .vertical
    } else {
      return nil
    }
  }

  public var debugColour: Color {
    toUnitPoint.debugColour
  }

  public var toUnitPoint: UnitPoint {
    switch self {
      case .topLeading: UnitPoint.topLeading
      case .topTrailing: UnitPoint.topTrailing
      case .bottomLeading: UnitPoint.bottomLeading
      case .bottomTrailing: UnitPoint.bottomTrailing

      case .top: UnitPoint.top
      case .trailing: UnitPoint.trailing
      case .leading: UnitPoint.leading
      case .bottom: UnitPoint.bottom
    }
  }

  public var toCompatPointerStyle: CompatiblePointerStyle {
    let style = CompatiblePointerStyle.frameResize(
      position: self.toCompatFrameResizePosition,
      directions: .all
    )
    return style
  }

  public var toCompatFrameResizePosition: CompatibleFrameResizePosition {
    switch self {
      case .topLeading: .topLeading
      case .topTrailing: .topTrailing
      case .bottomLeading: .bottomLeading
      case .bottomTrailing: .bottomTrailing
      case .top: .top
      case .trailing: .trailing
      case .leading: .leading
      case .bottom: .bottom
    }
  }
}

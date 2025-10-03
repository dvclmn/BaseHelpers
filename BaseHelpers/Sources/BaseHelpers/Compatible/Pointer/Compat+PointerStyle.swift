//
//  Pointer.swift
//  Collection
//
//  Created by Dave Coleman on 19/9/2024.
//

import SwiftUI

public enum FrameResizePositionCompatible: Int8, CaseIterable, Sendable {
  case top
  case leading
  case bottom
  case trailing
  case topLeading
  case topTrailing
  case bottomLeading
  case bottomTrailing
}

public enum FrameResizeDirectionCompatible: Int8, CaseIterable, Sendable {

  /// Indicates that the frame can be resized inwards to be smaller.
  case inward

  /// Indicates that the frame can be resized outwards to be larger.
  case outward
  
  case all
}

public enum PointerStyleCompatible: Sendable {
  case `default`
  case horizontalText
  case verticalText
  case rectSelection
  case grabIdle
  case grabActive
  case link
  case zoomIn
  case zoomOut
  case columnResize
  case rowResize
  
//#if canImport(AppKit)
  case frameResize(position: FrameResizePositionCompatible, directions: FrameResizeDirectionCompatible = .all)  //(position: FrameResizePosition, directions: FrameResizeDirection.Set = .all) -> PointerStyle
  case image(Image, hotSpot: UnitPoint)  // (_ image: Image, hotSpot: UnitPoint) -> PointerStyle
//#endif
}

#if canImport(AppKit)
extension FrameResizePositionCompatible {
  @available(macOS 15, *)
  var toResizePosition: FrameResizePosition {
    switch self {
      case .top: .top
      case .leading: .leading
      case .bottom: .bottom
      case .trailing: .trailing
      case .topLeading: .topLeading
      case .topTrailing: .topTrailing
      case .bottomLeading: .bottomLeading
      case .bottomTrailing: .bottomTrailing
    }
  }
}
extension FrameResizeDirectionCompatible {
  @available(macOS 15, *)
  var toResizeDirection: FrameResizeDirection.Set {
    switch self {
      case .inward: .inward
      case .outward: .outward
      case .all: .all
    }
  }
}
#endif

// MARK: - Private Extension for Conversion
extension PointerStyleCompatible {
#if canImport(AppKit)
  @available(macOS 15, *)
  var toPointerStyle: PointerStyle {
    switch self {
      case .default: .default
      case .horizontalText: .horizontalText
      case .verticalText: .rectSelection
      case .rectSelection: .rectSelection
      case .grabIdle: .grabIdle
      case .grabActive: .grabActive
      case .link: .link
      case .zoomIn: .zoomIn
      case .zoomOut: .zoomOut
      case .columnResize: .columnResize
      case .rowResize: .rowResize
      case .frameResize(let position, let direction): .frameResize(
        position: position.toResizePosition,
        directions: direction.toResizeDirection
      )
      case .image(let image, let hotSpot): .image(image, hotSpot: hotSpot)
    }
  }
#endif
}


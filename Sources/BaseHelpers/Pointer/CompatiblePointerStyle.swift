//
//  Pointer.swift
//  Collection
//
//  Created by Dave Coleman on 19/9/2024.
//

#if canImport(AppKit)
import SwiftUI

public enum CompatibleFrameResizePosition : Int8, CaseIterable {
  case top
  case leading
  case bottom
  case trailing
  case topLeading
  case topTrailing
  case bottomLeading
  case bottomTrailing
}


public enum CompatibleFrameResizeDirection: Int8, CaseIterable {
  
  /// Indicates that the frame can be resized inwards to be smaller.
  case inward
  
  /// Indicates that the frame can be resized outwards to be larger.
  case outward
}

public enum CompatiblePointerStyle: Sendable {
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
//  case columnResize // columnResize(directions: HorizontalDirection.Set)
  
  case rowResize
//  case rowResize // (directions: VerticalDirection.Set) -> PointerStyle
  case frameResize //(position: FrameResizePosition, directions: FrameResizeDirection.Set = .all) -> PointerStyle
  case image(Image, hotSpot: UnitPoint) // (_ image: Image, hotSpot: UnitPoint) -> PointerStyle
 
// MARK: - ViewModifier
private struct CustomPointerModifier: ViewModifier {
  let type: CompatiblePointerType
  
  func body(content: Content) -> some View {
    if #available(macOS 15, *) {
      content.pointerStyle(type.toPointerStyle)
    } else {
      content
    }
  }
}

// MARK: - Private Extension for Conversion
private extension CompatiblePointerType {
  @available(macOS 15, *)
  var toPointerStyle: PointerStyle {
    switch self {
      case .default:
          .default
      case .grabActive:
          .grabActive
      case .grabIdle:
          .grabIdle
      case .horizontalText:
          .horizontalText
      case .link:
          .link
      case .rectSelection:
          .rectSelection
        
      case .columnResize:
          .columnResize
        
      case .rowResize:
          .rowResize
        
      case .bottomResize:
          .frameResize(position: .bottom)
        
      case .bottomLeadingResize:
          .frameResize(position: .bottomLeading)
        
      case .bottomTrailingResize:
          .frameResize(position: .bottomTrailing)
        
      case .leadingResize:
          .frameResize(position: .leading)
        
      case .topResize:
          .frameResize(position: .top)
        
      case .topLeadingResize:
          .frameResize(position: .topLeading)
        
      case .topTrailingResize:
          .frameResize(position: .topTrailing)
        
      case .trailingResize:
          .frameResize(position: .trailing)
        
      case .verticalText:
          .verticalText
        
      case .zoomIn:
          .zoomIn
        
      case .zoomOut:
          .zoomOut
    }
  }
}

// MARK: - View Extension
public extension View {
  /// Applies a custom pointer style to a view that gracefully degrades on older macOS versions.
  /// - Parameter type: The desired pointer style type.
  /// - Returns: A view with the specified pointer style applied (macOS 15+) or unchanged (earlier versions).
  func customPointer(_ type: CompatiblePointerType) -> some View {
    modifier(CustomPointerModifier(type: type))
  }
}
#endif

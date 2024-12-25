//
//  Pointer.swift
//  Collection
//
//  Created by Dave Coleman on 19/9/2024.
//

#if canImport(AppKit)
import SwiftUI

/// A type-safe wrapper for system pointer styles that gracefully degrades on older macOS versions.
/// Provides a comprehensive set of pointer styles for different interactive contexts.
public enum CustomPointerType {
  
  /// The pointer style that uses the default platform appearance.
  case `default`
  
  /// The pointer style appropriate for actively dragging to reposition content within specific bounds,
  /// such as panning a large image.
  case grabActive
  
  /// The pointer style appropriate to indicate that dragging to reposition content within specific bounds,
  /// such as panning a large image, is possible.
  case grabIdle
  
  /// The pointer style appropriate for selecting or inserting text in a horizontal layout.
  case horizontalText
  
  /// The pointer style appropriate for content that opens a URL link to a webpage, document,
  /// or other item when clicked.
  case link
  
  /// The pointer style appropriate for precise rectangular selection,
  /// such as selecting a portion of an image or multiple lines of text.
  case rectSelection
  
  /// The pointer style for resizing a column, or vertical division, in either direction.
  case columnResize
  
  /// The pointer style for resizing a row, or horizontal division, in either direction.
  case rowResize
  
  case bottomResize
  
  case bottomLeadingResize
  
  case bottomTrailingResize
  
  case leadingResize
  
  case topResize
  
  case topLeadingResize
  
  case topTrailingResize
  
  case trailingResize
  
  /// The pointer style appropriate for selecting or inserting text in a vertical layout.
  case verticalText
  
  /// The pointer style appropriate to indicate that the content can be zoomed in.
  case zoomIn
  
  /// The pointer style appropriate to indicate that the content can be zoomed out.
  case zoomOut
}

// MARK: - ViewModifier
private struct CustomPointerModifier: ViewModifier {
  let type: CustomPointerType
  
  func body(content: Content) -> some View {
    if #available(macOS 15, *) {
      content.pointerStyle(type.toPointerStyle)
    } else {
      content
    }
  }
}

// MARK: - Private Extension for Conversion
private extension CustomPointerType {
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
  func customPointer(_ type: CustomPointerType) -> some View {
    modifier(CustomPointerModifier(type: type))
  }
}
#endif

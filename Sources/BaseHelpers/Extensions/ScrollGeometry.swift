//
//  ScrollGeometry.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 10/3/2025.
//

import SwiftUI

@available(macOS 15.0, iOS 18.0, *)
extension ScrollGeometry {
  public var displayString: String {
    """
    ScrollGeometry:
      Content Offset: x \(contentOffset.x), y \(contentOffset.y)
      Content Size: width \(contentSize.width), height \(contentSize.height)
      Content Insets: top \(contentInsets.top), leading \(contentInsets.leading), bottom \(contentInsets.bottom), trailing \(contentInsets.trailing)
      Container Size: width \(containerSize.width), height \(containerSize.height)
      Visible Rect: x \(visibleRect.origin.x), y \(visibleRect.origin.y), width \(visibleRect.size.width), height \(visibleRect.size.height)
    """
  }
}

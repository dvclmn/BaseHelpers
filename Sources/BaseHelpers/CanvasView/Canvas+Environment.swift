//
//  Canvas+Environment.swift
//  BaseComponents
//
//  Created by Dave Coleman on 8/7/2025.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
  
  @Entry public var canvasZoom: CGFloat = 1.0
  @Entry public var canvasZoomRange: ClosedRange<CGFloat>? = nil
  @Entry public var canvasPan: CGSize = .zero
  @Entry public var canvasSize: CGSize = .zero
  @Entry public var isResizingCanvas: Bool = false
  @Entry public var isHoverEnabled: Bool = true
  @Entry public var isDragEnabled: Bool = true
  @Entry public var shouldRenderDragRect: Bool = true
}

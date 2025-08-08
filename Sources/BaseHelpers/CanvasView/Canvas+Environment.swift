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
  
  //  @Entry public var enabledGestures: EnabledGestures = .all
  @Entry public var isPanEnabled: Bool = true
  @Entry public var isZoomEnabled: Bool = true
  @Entry public var isTapEnabled: Bool = true
  @Entry public var isHoverEnabled: Bool = true
  @Entry public var isDragEnabled: Bool = true
  @Entry public var shouldRenderDragRect: Bool = true

  
//  @Entry public var viewportSize: CGSize? = nil
}

extension View {
  //  public func setEnabledGestures(_ enabled: EnabledGestures) -> some View {
  //    self
  //      .environment(\.isPanEnabled, enabled.contains(.pan))
  //      .environment(\.isZoomEnabled, enabled.contains(.zoom))
  //      .environment(\.isTapEnabled, enabled.contains(.tap))
  //      .environment(\.isHoverEnabled, enabled.contains(.hover))
  //      .environment(\.isDragPanEnabled, enabled.contains(.dragPan))
  //  }
  //
  public func isDragEnabled(_ isEnabled: Bool) -> some View {
    self.environment(\.isDragEnabled, isEnabled)
  }
  public func setIsPanEnabled(_ isEnabled: Bool) -> some View {
    self.environment(\.isPanEnabled, isEnabled)
  }
  public func setIsZoomEnabled(_ isEnabled: Bool) -> some View {
    self.environment(\.isZoomEnabled, isEnabled)
  }
  public func setIsTapEnabled(_ isEnabled: Bool) -> some View {
    self.environment(\.isTapEnabled, isEnabled)
  }
  public func setIsHoverEnabled(_ isEnabled: Bool) -> some View {
    self.environment(\.isHoverEnabled, isEnabled)
  }
  public func setShouldRenderDragRect(_ shouldRender: Bool) -> some View {
    self.environment(\.shouldRenderDragRect, shouldRender)
  }
  
  // MARK: - Canvas Zoom, Pan, Size
  public func setZoomLevel(_ zoom: CGFloat) -> some View {
    self.environment(\.canvasZoom, zoom)
  }
  public func setZoomRange(_ range: ClosedRange<CGFloat>) -> some View {
    self.environment(\.canvasZoomRange, range)
  }
  public func setPanOffset(_ pan: CGSize) -> some View {
    self.environment(\.canvasPan, pan)
  }
  public func setCanvasSize(_ size: CGSize) -> some View {
    self.environment(\.canvasSize, size)
  }
}

//public struct ViewportSizeEnvironmentModifier: ViewModifier {
//  @State private var viewportSizeLocal: CGSize = .zero
//  public func body(content: Content) -> some View {
//    content
//      .viewSize(mode: .noDebounce) { size in
//        self.viewportSizeLocal = size
//      }
//      .environment(\.viewportSize, viewportSizeLocal)
//  }
//}
//
//extension View {
//  public func viewportSizeEnvironment() -> some View {
//    self.modifier(ViewportSizeEnvironmentModifier())
//  }
//}

//public struct EnabledGestures: OptionSet, Sendable {
//  public init(rawValue: Int) {
//    self.rawValue = rawValue
//  }
//  public let rawValue: Int
//
//  public static let zoom = Self(rawValue: 1 << 0)
//  public static let pan = Self(rawValue: 1 << 1)
//  public static let hover = Self(rawValue: 1 << 2)
//  public static let tap = Self(rawValue: 1 << 3)
//  public static let dragPan = Self(rawValue: 1 << 4)
//  public static let all: Self = [
//    .zoom, .pan, .hover, .tap, .dragPan
//  ]
//}

//
//  File.swift
//
//
//  Created by Dave Coleman on 26/7/2024.
//

import SwiftUI
import Dependencies

/// TCA Dependancy stuff
///
public extension DependencyValues {
  var windowDimensions: WindowSizeHandler {
    get { self[WindowSizeHandler.self] }
    set { self[WindowSizeHandler.self] = newValue }
  }
}

extension WindowSizeHandler: DependencyKey {
  public static let liveValue = WindowSizeHandler()
  public static var testValue = WindowSizeHandler()
}

@Observable
public final class WindowSizeHandler: Sendable {

  public var size: CGSize
  
  public init(
    size: CGSize = .zero
  ) {
    self.size = size
  }
}

public struct WindowSizeModifier: ViewModifier {
  @Dependency(\.windowDimensions) var windowSize
  
  public func body(content: Content) -> some View {
    content
      
    /// Important note:
    ///
    /// Previously this modifier was not correctly reporting the full window size.
    /// I found this was because I'd tried the `.ignoresSafeArea()` inside
    /// the background modifier, as well as above, but these weren't the correct
    /// locations! Now that it is located *below* everything else, the geo reader
    /// is returning the correct size.
    ///
      .background(
        GeometryReader { geometry in
          Color.clear
            .task(id: geometry.size) {
//              print("Window size: '\(geometry.size.width)x\(geometry.size.height)'")
              windowSize.size = geometry.size
            }
        }
      )
    /// Keep this down here, beneath the background/GeometryReader,
    /// for an accurate reading of the window size.
      .ignoresSafeArea()
  }
}

public extension View {
  func readWindowSize() -> some View {
    self.modifier(WindowSizeModifier())
  }
}

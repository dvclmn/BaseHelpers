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
public class WindowSizeHandler {

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
      .background(
        GeometryReader { geometry in
          Color.clear
            .task(id: geometry.size) {
              windowSize.size = geometry.size
            }
        }
      )
  }
}

public extension View {
  func readWindowSize() -> some View {
    self.modifier(WindowSizeModifier())
  }
}

// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI


extension EnvironmentValues {
  @Entry public var windowSize: CGSize = .zero
}

public struct WindowSizeModifier: ViewModifier {
  @State private var size: CGSize = .zero
  
  public init() {
  }
  
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
//              print("Window size: \(geometry.size)")
              size = geometry.size
            }
        }
      )
      .environment(\.windowSize, size)
    /// Keep this down here, beneath the background/GeometryReader,
    /// for an accurate reading of the window size.
      .ignoresSafeArea()
  }
}

extension View {
  public func readWindowSize() -> some View {
    self.modifier(WindowSizeModifier())
  }
}

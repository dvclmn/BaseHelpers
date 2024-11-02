//
//  ScrollOffset.swift
//  Collection
//
//  Created by Dave Coleman on 2/11/2024.
//

import SwiftUI

private struct ScrollOffsetPreferenceKey: PreferenceKey {
  static var defaultValue: CGPoint = .zero
  static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
    value = nextValue()
  }
}


public extension View {
  /// Tracks the scroll offset of a view within a ScrollView with debouncing
  /// - Parameters:
  ///   - coordinateSpaceName: The coordinate space name (must match ScrollView's coordinateSpace)
  ///   - debounceInterval: Time interval to debounce scroll events
  ///   - onChange: Closure called with debounced scroll offset values
  func trackScrollOffset(
    coordinateSpaceName name: String = "scroll",
    debounceInterval: Duration = .milliseconds(100),
    onChange: @escaping (CGPoint) -> Void
  ) -> some View {
    modifier(ScrollOffsetTracker(
      coordinateSpaceName: name,
      debounceInterval: debounceInterval,
      onChange: onChange
    ))
  }
}


/// A view modifier that handles scroll offset tracking with debouncing
private struct ScrollOffsetTracker: ViewModifier {
  let coordinateSpaceName: String
  let debounceInterval: Duration
  let onChange: (CGPoint) -> Void
  
  @State private var debouncer: ScrollDebouncer
  
  init(coordinateSpaceName: String, debounceInterval: Duration, onChange: @escaping (CGPoint) -> Void) {
    self.coordinateSpaceName = coordinateSpaceName
    self.debounceInterval = debounceInterval
    self.onChange = onChange
    
    // Initialize the StateObject with a default value
    _debouncer = State(initialValue: ScrollDebouncer(interval: debounceInterval, onChange: onChange))
  }
  
  func body(content: Content) -> some View {
    
    content
      .background(
        GeometryReader { proxy in
          Color.clear
            .preference(
              key: ScrollOffsetPreferenceKey.self,
              value: proxy.frame(in: .named(coordinateSpaceName)).origin
            )
        }
      )
      .onPreferenceChange(ScrollOffsetPreferenceKey.self) { point in
        debouncer.send(point)
      }
  }
}


@MainActor
@Observable
private final class ScrollDebouncer {
  private let debouncer: Debouncer<CGPoint>
  
  init(interval: Duration, onChange: @escaping (CGPoint) -> Void) {
    self.debouncer = Debouncer(interval: interval, action: onChange)
  }
  
  func send(_ point: CGPoint) {
    debouncer.send(point)
  }
}


public struct OffsetScroll<Content: View>: View {
  
  @State private var offset: CGFloat = .zero
  
  let content: Content
  
  init(
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.content = content()
  }
  
  public var body: some View {
    
    ScrollView {
      VStack {
        content
      }
      .trackScrollOffset { point in
//        print("Debounced scroll offset: \(point)")
        self.offset = point.y
      }
    }
    .coordinateSpace(name: "scroll")
    .overlay(alignment: .topLeading) {
      Text("Scroll offset: \(self.offset)")
    }
    
  }
}

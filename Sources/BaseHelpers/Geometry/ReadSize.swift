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




/// When applied, using ``
///
//public extension EnvironmentValues {
//  @Entry var windowSize: CGSize = .zero
//}
//
//public struct WindowSizeModifier: ViewModifier {
//  
//  @State private var size: CGSize = .zero
//  
//  public func body(content: Content) -> some View {
//    content
//      .onGeometryChange(for: CGSize.self) { proxy in
//        return proxy.size
//      } action: { newSize in
//        print("Size: \(newSize)")
//        size = newSize
//      }
//      .environment(\.windowSize, size)
//
//  }
//}
//public extension View {
//  func readViewSize(
//  ) -> some View {
//    self.modifier(WindowSizeModifier())
//  }
//}

//public typealias SizeOutput = (CGSize) -> Void
//
//public extension View {
//  func readSize(onChange: @escaping SizeOutput) -> some View {
//    background(
//      GeometryReader { geometryProxy in
//        Color.clear
//          .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
//      }
//    )
//    .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
//  }
//}
//
//private struct SizePreferenceKey: PreferenceKey {
//  static let defaultValue: CGSize = .zero
//  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
//}


//public struct ReadSizeDebouncedModifier: ViewModifier {
//  
//  @State private var debouncer: DebounceValue<CGSize>
//  
//  let onChange: SizeOutput
//  
//  public init(onChange: @escaping SizeOutput) {
//    self.onChange = onChange
//    // Initialize the State wrapper directly
//    _debouncer = State(initialValue: DebounceValue(.zero))
//  }
//  
//  public func body(content: Content) -> some View {
//    content
//      .background {
//        GeometryReader { geometryProxy in
//          Color.clear
//            .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
//        }
//      }
//      .onPreferenceChange(SizePreferenceKey.self) { newSize in
//        debouncer.update(with: newSize)
//      }
//    
//      .onAppear {
//        print("Checking signal noise for `ReadSizeDebouncedModifier`")
//        // Set up the callback when the view appears
//        debouncer.valueChanged = onChange
//      }
//    
//  }
//}
//
//public extension View {
//  func readSizeDebounced(onChange: @escaping SizeOutput) -> some View {
//    modifier(ReadSizeDebouncedModifier(onChange: onChange))
//  }
//}



/// https://saeedrz.medium.com/detect-scroll-position-in-swiftui-3d6e0d81fc6b
/// For `readFrame` to work, the `readFrame` modifier must be placed on a view (e.g. VStack) *within*
/// the ScrollView, and a `.coordinateSpace(name: "scroll")` modifier placed on the ScrollView itself.
///
//public extension View {
//  func readFrame(coordinateSpaceName name: String = "scroll", onChange: @escaping (CGPoint) -> Void) -> some View {
//    background(
//      GeometryReader { geometryProxy in
//        Color.clear
//          .preference(key: FramePreferenceKey.self, value: geometryProxy.frame(in: .named(name)).origin)
//      }
//    )
//    .onPreferenceChange(FramePreferenceKey.self, perform: onChange)
//  }
//}
//
//private struct FramePreferenceKey: PreferenceKey {
//  static let defaultValue: CGPoint = .zero
//  static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
//}



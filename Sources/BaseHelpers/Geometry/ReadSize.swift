// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI


//public extension View {
//  func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
//    background(
//      GeometryReader { geometryProxy in
//        Color.clear
//          .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
//      }
//    )
//    .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
//  }
//}

public typealias SizeOutput = (CGSize) -> Void

public struct ReadSizeModifier: ViewModifier {
  
  @State private var viewSize: CGSize = .zero
  
  let onChange: SizeOutput
  
  public func body(content: Content) -> some View {
    content
      .background {
        GeometryReader { geometryProxy in
          Color.clear
            .task(id: geometryProxy.size) {
              self.viewSize = geometryProxy.size
            }
        }
      }
  }
}
public extension View {
  func readSize(onChange: @escaping SizeOutput) -> some View {
    modifier(ReadSizeModifier(onChange: onChange))
  }
}




public struct ReadSizeDebouncedModifier: ViewModifier {
  
  @State private var debouncer: DebounceValue<CGSize>
  
  let onChange: SizeOutput
  
  public init(onChange: @escaping SizeOutput) {
    self.onChange = onChange
    // Initialize the State wrapper directly
    _debouncer = State(initialValue: DebounceValue(.zero))
  }
  
  public func body(content: Content) -> some View {
    content
      .background {
        GeometryReader { geometryProxy in
          Color.clear
            .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
        }
      }
      .onPreferenceChange(SizePreferenceKey.self) { newSize in
        debouncer.update(with: newSize)
      }
    
      .onAppear {
        // Set up the callback when the view appears
        debouncer.valueChanged = onChange
      }
    
  }
}

public extension View {
  func readSizeDebounced(onChange: @escaping SizeOutput) -> some View {
    modifier(ReadSizeDebouncedModifier(onChange: onChange))
  }
}

private struct SizePreferenceKey: PreferenceKey {
  static let defaultValue: CGSize = .zero
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}



/// https://saeedrz.medium.com/detect-scroll-position-in-swiftui-3d6e0d81fc6b
/// For `readFrame` to work, the `readFrame` modifier must be placed on a view (e.g. VStack) *within*
/// the ScrollView, and a `.coordinateSpace(name: "scroll")` modifier placed on the ScrollView itself.
///
public extension View {
  func readFrame(coordinateSpaceName name: String = "scroll", onChange: @escaping (CGPoint) -> Void) -> some View {
    background(
      GeometryReader { geometryProxy in
        Color.clear
          .preference(key: FramePreferenceKey.self, value: geometryProxy.frame(in: .named(name)).origin)
      }
    )
    .onPreferenceChange(FramePreferenceKey.self, perform: onChange)
  }
}

private struct FramePreferenceKey: PreferenceKey {
  static let defaultValue: CGPoint = .zero
  static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}



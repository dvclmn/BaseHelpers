// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

// MARK: - Use GeometryReader to get the size of the view
public extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}



/// https://saeedrz.medium.com/detect-scroll-position-in-swiftui-3d6e0d81fc6b
/// For `readFrame` to work, the `readFrame` modifier must be placed on a view (e.g. VStack) *within* the ScrollView, and a `.coordinateSpace(name: "scroll")` modifier placed on the ScrollView itself.
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
    static var defaultValue: CGPoint = .zero
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}




public struct WindowDimensions: Sendable {
    public var width: CGFloat
    public var height: CGFloat
    
    public init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }
}

public struct WindowDimensionsKey: EnvironmentKey {
    public static let defaultValue = WindowDimensions(width: .zero, height: .zero)
}

public extension EnvironmentValues {
    var windowDimensions: WindowDimensions {
        get { self[WindowDimensionsKey.self] }
        set { self[WindowDimensionsKey.self] = newValue }
    }
}


public struct WindowDimensionsModifier: ViewModifier {
    @State private var windowDimensions = WindowDimensions(width: 0, height: 0)
    
    public func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            self.windowDimensions = WindowDimensions(
                                width: geometry.size.width,
                                height: geometry.size.height
                            )
                        }
                        .onChange(of: geometry.size) {
                            self.windowDimensions = WindowDimensions(
                                width: geometry.size.width,
                                height: geometry.size.height
                            )
                        }
                }
            )
            .environment(\.windowDimensions, windowDimensions)
    }
}

public extension View {
    func readWindowSize() -> some View {
        self.modifier(WindowDimensionsModifier())
    }
}

//
//  File.swift
//
//
//  Created by Dave Coleman on 14/7/2024.
//

import Foundation
import SwiftUI
import ScrollKit

//public extension View {
//    func readSize(
//        onChange: @escaping (CGSize) -> Void
//    ) -> some View {
//
//        background(
//            GeometryReader { geometryProxy in
//                Color.clear
//                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
//            }
//        )
//        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
//    }
//}
//
//private struct SizePreferenceKey: PreferenceKey {
//    static var defaultValue: CGSize = .zero
//    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
//}
//


//public struct ScrollOffset: Sendable {
//    public var offset: CGPoint
//
//    public init(offset: CGPoint) {
//        self.offset = offset
//    }
//}
//
//public struct ScrollOffsetKey: EnvironmentKey {
//    public static let defaultValue = ScrollOffset(offset: .zero)
//}
//
//public extension EnvironmentValues {
//    var scrollOffset: ScrollOffset {
//        get { self[ScrollOffsetKey.self] }
//        set { self[ScrollOffsetKey.self] = newValue }
//    }
//}

public struct ScrollOffsetModifier: ViewModifier {
    
    let output: (_ offset: CGPoint) -> Void
    
    public init(output: @escaping (_ offset: CGPoint) -> Void) {
        self.output = output
    }
    
    public func body(content: Content) -> some View {
        
        ScrollViewWithOffsetTracking(showsIndicators: true) { offset in
            output(offset)
        } content: {
            content
        }
    }
}

public extension View {
    
    func readScrollOffset(_ output: @escaping (_ offset: CGPoint) -> Void) -> some View {
        self.modifier(ScrollOffsetModifier(output: output))
    }
    
}

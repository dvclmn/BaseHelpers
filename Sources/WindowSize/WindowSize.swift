//
//  File.swift
//
//
//  Created by Dave Coleman on 26/7/2024.
//

import SwiftUI
import Dependencies



public extension DependencyValues {
    var windowSize: WindowSizeHandler {
        get { self[WindowSizeKey.self] }
        set { self[WindowSizeKey.self] = newValue }
    }
}

public struct WindowSizeKey: DependencyKey {
    public static let liveValue = WindowSizeHandler()
    public static var testValue = WindowSizeHandler()
}


public struct WindowSize: Sendable {
    public var width: CGFloat
    public var height: CGFloat
    
    public init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }
}

@Observable
public class WindowSizeHandler {
    public var size: WindowSize

    public init(size: WindowSize = WindowSize(width: .zero, height: .zero)) {
        self.size = size
    }
}

public struct WindowSizeModifier: ViewModifier {
    @Dependency(\.windowSize) var windowSizeHolder
    
    public func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .task(id: geometry.size) {
                            updateWindowSize(geometry.size)
                        }
                }
            )
    }
    
    private func updateWindowSize(_ size: CGSize) {
        windowSizeHolder.size = WindowSize(width: size.width, height: size.height)
    }
}

public extension View {
    func readWindowSize() -> some View {
        self.modifier(WindowSizeModifier())
    }
}

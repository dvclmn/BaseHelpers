//
//  CoordinateSpaces.swift
//  Collection
//
//  Created by Dave Coleman on 16/11/2024.
//

import SwiftUI

public struct CoordinateSpaceDebugger: ViewModifier {
  @State private var localFrame: CGRect = .zero
  @State private var globalFrame: CGRect = .zero
  @State private var namedFrame: CGRect = .zero
  @State private var isDragging = false
  
  let nameSpace: String
  let showGuides: Bool
  
  public init(nameSpace: String, showGuides: Bool = true) {
    self.nameSpace = nameSpace
    self.showGuides = showGuides
  }
  
  public func body(content: Content) -> some View {
    content
      .overlay(
        GeometryReader { localGeo in
          ZStack {
            /// Debug visualization
            if showGuides {
              /// Local space grid
              GridPattern(spacing: 20)
                .stroke(Color.blue.opacity(0.2), lineWidth: 0.5)
              
              /// Axes
              Path { path in
                path.move(to: CGPoint(x: 0, y: localGeo.size.height/2))
                path.addLine(to: CGPoint(x: localGeo.size.width, y: localGeo.size.height/2))
                path.move(to: CGPoint(x: localGeo.size.width/2, y: 0))
                path.addLine(to: CGPoint(x: localGeo.size.width/2, y: localGeo.size.height))
              }
              .stroke(Color.blue.opacity(0.5), lineWidth: 1)
            }
            
            // Debug info overlay
            VStack(alignment: .leading, spacing: 4) {
              Text("Local: \(formatFrame(localFrame))")
                .foregroundColor(.blue)
              Text("Global: \(formatFrame(globalFrame))")
                .foregroundColor(.green)
              Text("Named '\(nameSpace)': \(formatFrame(namedFrame))")
                .foregroundColor(.orange)
            }
            .font(.system(size: 10, design: .monospaced))
            .padding(4)
            .background(Color.black.opacity(0.75))
            .cornerRadius(4)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
          }
        }
      )
    // Capture frames in different coordinate spaces
      .background(
        GeometryReader { geo in
          Color.clear
            .preference(key: CoordinateFramePreferenceKey.self, value: geo.frame(in: .local))
            .onPreferenceChange(CoordinateFramePreferenceKey.self) { frame in
              self.localFrame = frame
            }
        }
      )
      .background(
        GeometryReader { geo in
          Color.clear
            .preference(key: GlobalFramePreferenceKey.self, value: geo.frame(in: .global))
            .onPreferenceChange(GlobalFramePreferenceKey.self) { frame in
              self.globalFrame = frame
            }
        }
      )
      .background(
        GeometryReader { geo in
          Color.clear
            .preference(key: NamedFramePreferenceKey.self, value: geo.frame(in: .named(nameSpace)))
            .onPreferenceChange(NamedFramePreferenceKey.self) { frame in
              self.namedFrame = frame
            }
        }
      )
  }
  
  private func formatFrame(_ frame: CGRect) -> String {
    return String(format: "x:%.1f y:%.1f w:%.1f h:%.1f",
                  frame.origin.x, frame.origin.y,
                  frame.size.width, frame.size.height)
  }
}

/// Preference Keys for different coordinate spaces
struct CoordinateFramePreferenceKey: PreferenceKey {
  static let defaultValue: CGRect = .zero
  static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
    value = nextValue()
  }
}

struct GlobalFramePreferenceKey: PreferenceKey {
  static let defaultValue: CGRect = .zero
  static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
    value = nextValue()
  }
}

struct NamedFramePreferenceKey: PreferenceKey {
  static let defaultValue: CGRect = .zero
  static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
    value = nextValue()
  }
}

/// Helper view for drawing grid pattern
struct GridPattern: Shape {
  let spacing: CGFloat
  
  func path(in rect: CGRect) -> Path {
    var path = Path()
    
    /// Vertical lines
    stride(from: 0, through: rect.width, by: spacing).forEach { x in
      path.move(to: CGPoint(x: x, y: 0))
      path.addLine(to: CGPoint(x: x, y: rect.height))
    }
    
    /// Horizontal lines
    stride(from: 0, through: rect.height, by: spacing).forEach { y in
      path.move(to: CGPoint(x: 0, y: y))
      path.addLine(to: CGPoint(x: rect.width, y: y))
    }
    
    return path
  }
}

public extension View {
  func debugCoordinateSpace(named: String, showGuides: Bool = true) -> some View {
    self.modifier(CoordinateSpaceDebugger(nameSpace: named, showGuides: showGuides))
  }
}


struct CoordinateSpaceDebugView: View {
  
  var body: some View {
    
    VStack {
      Text("Hello, World!")
        .frame(width: 400, height: 700)
        .background(Color.gray)
        .debugCoordinateSpace(named: "custom")
    }
    .coordinateSpace(name: "custom")
    
  }
}
#if DEBUG
@available(macOS 15, iOS 18, *)
#Preview {
  CoordinateSpaceDebugView()
}
#endif


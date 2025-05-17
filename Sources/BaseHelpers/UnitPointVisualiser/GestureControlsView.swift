//
//  GestureControlsView.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 17/5/2025.
//

import SwiftUI

public struct GestureControlsView: View {
  @Environment(UnitPointHandler.self) private var store
  public var body: some View {
    
      GeometryReader { geometry in
        ZStack {
          // Line connecting start and end points
          Path { path in
            path.move(
              to: CGPoint(
                x: store.startPoint.x * geometry.size.width, y: store.startPoint.y * geometry.size.height)
            )
            path.addLine(
              to: CGPoint(
                x: store.endPoint.x * geometry.size.width, y: store.endPoint.y * geometry.size.height))
          }
          .stroke(Color.blue, lineWidth: 2)
          
          // Start point (red)
          Circle()
            .fill(Color.red)
            .frame(width: 20, height: 20)
            .position(
              x: store.startPoint.x * geometry.size.width, y: store.startPoint.y * geometry.size.height
            )
            .gesture(
              DragGesture()
                .onChanged { value in
                  store.startPoint = UnitPoint(
                    x: value.location.x / geometry.size.width,
                    y: value.location.y / geometry.size.height
                  )
                }
            )
          
          // End point (green)
          Circle()
            .fill(Color.green)
            .frame(width: 20, height: 20)
            .position(
              x: store.endPoint.x * geometry.size.width, y: store.endPoint.y * geometry.size.height
            )
            .gesture(
              DragGesture()
                .onChanged { value in
                  store.endPoint = UnitPoint(
                    x: value.location.x / geometry.size.width,
                    y: value.location.y / geometry.size.height
                  )
                }
            )
        }
      }

    
  }
}
//#if DEBUG
//@available(macOS 15, iOS 18, *)
//#Preview(traits: .size(.normal)) {
//  GestureControlsView()
//}
//#endif


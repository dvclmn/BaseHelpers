//
//  UnitPointVisualiser.swift
//  Components
//
//  Created by Dave Coleman on 23/9/2024.
//

import SwiftUI

public struct UnitPointVisualizer: View {
  @State private var startPoint = UnitPoint(x: 0.25, y: 0.25)
  @State private var endPoint = UnitPoint(x: 0.75, y: 0.75)

  public var body: some View {
    VStack {
      ZStack {
        Rectangle()
          .fill(.clear)
          .aspectRatio(1, contentMode: .fit)
          .overlay {
            GeometryReader { geometry in
              ZStack {
                // Line connecting start and end points
                Path { path in
                  path.move(
                    to: CGPoint(
                      x: startPoint.x * geometry.size.width, y: startPoint.y * geometry.size.height)
                  )
                  path.addLine(
                    to: CGPoint(
                      x: endPoint.x * geometry.size.width, y: endPoint.y * geometry.size.height))
                }
                .stroke(Color.blue, lineWidth: 2)

                // Start point (red)
                Circle()
                  .fill(Color.red)
                  .frame(width: 20, height: 20)
                  .position(
                    x: startPoint.x * geometry.size.width, y: startPoint.y * geometry.size.height
                  )
                  .gesture(
                    DragGesture()
                      .onChanged { value in
                        startPoint = UnitPoint(
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
                    x: endPoint.x * geometry.size.width, y: endPoint.y * geometry.size.height
                  )
                  .gesture(
                    DragGesture()
                      .onChanged { value in
                        endPoint = UnitPoint(
                          x: value.location.x / geometry.size.width,
                          y: value.location.y / geometry.size.height
                        )
                      }
                  )
              }
            }
          }  // END overlay
          .background {
            /// White stroke
            LinearGradient(
              colors: [
                .red.opacity(0.9),
                .red.opacity(0.1),
              ],
              startPoint: startPoint,
              endPoint: endPoint
            )
          }
          .background {
            /// Dark stroke
            LinearGradient(
              colors: [
                .green.opacity(0.1),
                .green.opacity(0.9),
              ],
              startPoint: startPoint,
              endPoint: endPoint
            )
          }
      }
      .frame(height: 300)

      VStack {
        //        Text("Start Point: \(startPoint)")
        Text("X: \(startPoint.x, specifier: "%.2f")")
        Slider(value: $startPoint.x)
        Text("Y: \(startPoint.y, specifier: "%.2f")")
        Slider(value: $startPoint.y)

        Divider().padding()

        //        Text("End Point: \(endPoint)")
        Text("X: \(endPoint.x, specifier: "%.2f")")
        Slider(value: $endPoint.x)
        Text("Y: \(endPoint.y, specifier: "%.2f")")
        Slider(value: $endPoint.y)
      }
      .padding()
    }
  }
}

#if DEBUG

#Preview("UnitPoint Visualiser") {
  UnitPointVisualizer()
    .frame(width: 400, height: 700)
}
#endif


//
//  ExampleDebugView.swift
//  BaseComponents
//
//  Created by Dave Coleman on 4/5/2025.
//

import SwiftUI

struct PathDebugExampleView: View {

  //  let currentAngle: Double = 80

  var body: some View {
    VStack(spacing: 40) {
      Text("ShapeDebug")
        .foregroundStyle(.white)

      ShapeDebug {
        RoundedRectangle(cornerRadius: 20)
//          .fill(.blue)
      }
      .frame(width: 300, height: 200)

      Text("CanvasPathDebug")
        .foregroundStyle(.white)

      Canvas { context, size in

        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let radius = min(size.width, size.height) / 2 * 0.7

        /// Draw circle
        let circlePath = Path { path in
          path.addArc(
            center: center,
            radius: radius,
            startAngle: .degrees(0),
            endAngle: .degrees(360),
            clockwise: false
          )
        }
        context.stroke(circlePath, with: .color(.gray), lineWidth: 2)
        context.debugPath(path: circlePath)

      }

    }
    .padding(40)
    .frame(width: 580, height: 700)
    .background(.black.opacity(0.6))
  }
}

#if DEBUG
#Preview {
  PathDebugExampleView()
}
#endif

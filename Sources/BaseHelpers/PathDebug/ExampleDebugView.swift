//
//  ExampleDebugView.swift
//  BaseComponents
//
//  Created by Dave Coleman on 4/5/2025.
//

import SwiftUI


struct PathDebugExampleView: View {
  
  let currentAngle: Double = 80
  
  var body: some View {
    VStack(spacing: 40) {
//      Text("ShapeDebugger")
//        .foregroundStyle(.white)
//      
//      ShapeDebugger {
//        RoundedRectangle(cornerRadius: 20)
//      }
//      .frame(width: 300, height: 200)
//      
//      Text("CanvasPathDebugger")
//        .foregroundStyle(.white)
//      
      
      Canvas { context, size in
        
        let center = CGPoint(x: size.width/2, y: size.height/2)
        let radius = min(size.width, size.height)/2 * 0.7
        
        // Draw outer circle
        let circlePath = Path { path in
          path.addArc(center: center,
                      radius: radius,
                      startAngle: .degrees(0),
                      endAngle: .degrees(360),
                      clockwise: false)
        }
        context.stroke(circlePath, with: .color(.gray), lineWidth: 2)
        
        // Pre-calculate common values
        let piOver2 = Double.pi/2
        let markRadius = radius * 0.9
        let fullRadius = radius
        //        let labelRadius = radius * 1.1
        
        // Draw angle marks
        for angle in stride(from: 0, to: 360, by: 30) {
          let angleRadians = Angle(degrees: Double(angle)).radians - piOver2
          let cosAngle = cos(angleRadians)
          let sinAngle = sin(angleRadians)
          
          let markStart = CGPoint(
            x: center.x + cosAngle * markRadius,
            y: center.y + sinAngle * markRadius
          )
          let markEnd = CGPoint(
            x: center.x + cosAngle * fullRadius,
            y: center.y + sinAngle * fullRadius
          )
          
          let isMajorMark = angle.isMultiple(of: 90)
          
          context.stroke(
            Path { path in
              path.move(to: markStart)
              path.addLine(to: markEnd)
            },
            with: .color(isMajorMark ? .red : .gray),
            lineWidth: isMajorMark ? 3.0 : 2.0
          )

        }
        
//        // Current angle indicator (full diameter)
//        let angleRadians = Angle(degrees: currentAngle).radians - .pi
//        let indicatorStart = CGPoint(
//          x: center.x - cos(angleRadians) * radius * 0.8,
//          y: center.y - sin(angleRadians) * radius * 0.8
//        )
//        let indicatorEnd = CGPoint(
//          x: center.x + cos(angleRadians) * radius * 0.8,
//          y: center.y + sin(angleRadians) * radius * 0.8
//        )
//        
//        let indicatorColour: Color = currentAngle == 0 ? .blue : .green
//        
//        context.stroke(
//          Path { path in
//            path.move(to: indicatorStart)
//            path.addLine(to: indicatorEnd)
//          },
//          with:  .color(indicatorColour),
//          lineWidth: 2
//        )
//        let myPath = someDrawingFunction(size)
        
//        context.stroke(myPath, with: .color(.blue))
        
        CanvasPathDebugger.render(
          into: context,
          size: size,
          path: circlePath,
          config: .init()
        )
      }
      
//      CanvasPathDebugger(
//        pathBuilder: { size in
//          var path = Path()
//          path.addRoundedRect(in: CGRect(origin: .zero, size: size), cornerSize: CGSize(width: 20, height: 20))
//          return path
//        },
//        config: .init()
//      )
//      .frame(width: 300, height: 200)
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


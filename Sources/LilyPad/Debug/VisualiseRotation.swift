//
//  Debug.swift
//  LilyPad
//
//  Created by Dave Coleman on 28/11/2024.
//

import SwiftUI

struct RotationDebugGauge: View {
  
  let currentAngle: Double
  
  init(currentAngle: Double = .zero) {
    self.currentAngle = currentAngle
  }
  
  var body: some View {
    VStack {
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
          
          // Label each mark
          //          let labelPoint = CGPoint(
          //            x: center.x + cos(angleRadians - 3 * .pi/2) * labelRadius,
          //            y: center.y + sin(angleRadians - 3 * .pi/2) * labelRadius
          //          )
          //
          //          context.draw(
          //            Text("\(angle)°/\(String(format: "%.2f", Double(angle) * .pi / 90))r")
          //              .font(.system(size: 10)),
          //            at: labelPoint,
          //            anchor: .center
          //          )
        }
        
        // Current angle indicator (full diameter)
        let angleRadians = Angle(degrees: currentAngle).radians - .pi
        let indicatorStart = CGPoint(
          x: center.x - cos(angleRadians) * radius * 0.8,
          y: center.y - sin(angleRadians) * radius * 0.8
        )
        let indicatorEnd = CGPoint(
          x: center.x + cos(angleRadians) * radius * 0.8,
          y: center.y + sin(angleRadians) * radius * 0.8
        )
        
        let indicatorColour: Color = currentAngle == 0 ? .blue : .green
        
        context.stroke(
          Path { path in
            path.move(to: indicatorStart)
            path.addLine(to: indicatorEnd)
          },
          with:  .color(indicatorColour),
          lineWidth: 2
        )
      }
      
      //      Slider(value: $currentAngle, in: 0...360)
      //        .padding()
      
      .overlay {
        Text("\(Int(currentAngle))°/\(String(format: "%.2f", currentAngle * .pi / 180))r")
        
          .font(.callout.weight(.medium))
          .foregroundStyle(.secondary)
          .padding(4)
          .background {
            RoundedRectangle(cornerRadius: 6)
              .fill(.black.opacity(0.6))
          }
          .offset(y: -20)
      }
    }
  }
}

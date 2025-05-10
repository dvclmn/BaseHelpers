//
//  LineBtweenPoints.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 10/5/2025.
//

import SwiftUI

public struct AngleLineModifier: ViewModifier {
  var point1: CGPoint
  var point2: CGPoint
  var lineColor: Color = .blue
  var textColor: Color = .white
  var textBackgroundColor: Color = .black.opacity(0.7)
  var lineWidth: CGFloat = 2

  public func body(content: Content) -> some View {
    content
      .overlay(
        AngleLineView(
          point1: point1,
          point2: point2,
          lineColor: lineColor,
          textColor: textColor,
          textBackgroundColor: textBackgroundColor,
          lineWidth: lineWidth
        )
      )
  }
}

public struct AngleLineView: View {
  var point1: CGPoint
  var point2: CGPoint
  var lineColor: Color
  var textColor: Color
  var textBackgroundColor: Color
  var lineWidth: CGFloat

  private var angle: Double {
    /// Calculate angle (counterclockwise from positive x-axis)
    let deltaX = point2.x - point1.x
    let deltaY = point2.y - point1.y

    return atan2(deltaY, deltaX)
  }

  private var angleInDegrees: Double {
    // Convert radians to degrees
    return angle * 180 / .pi
  }

  public var body: some View {
    Canvas { context, size in
      // Draw line between the two points
      let path = Path { path in
        path.move(to: point1)
        path.addLine(to: point2)
      }

      context.stroke(path, with: .color(lineColor), lineWidth: lineWidth)

//      // Create the text to display
//      let degreesText = String(format: "%.1f°", angleInDegrees)
//      let radiansText = String(format: "%.2f rad", angle)
//      let angleText = "\(degreesText)\n\(radiansText)"
//
//      // Create text resolver to get text dimensions
//      let resolver = context.resolve(
//        Text(angleText)
//          .font(.system(size: 12))
//          .foregroundColor(textColor)
//          .multilineTextAlignment(.center))

      // Position the text at the midpoint
//      let textSize = resolver.measure(in: size)
//      let textRect = CGRect(
//        x: midpoint.x - textSize.width / 2,
//        y: midpoint.y - textSize.height / 2,
//        width: textSize.width,
//        height: textSize.height
//      )

//      // Draw background for text
//      let backgroundRect = textRect.insetBy(dx: -5, dy: -3)
//      let backgroundPath = Path(roundedRect: backgroundRect, cornerRadius: 4)
//      context.fill(backgroundPath, with: .color(textBackgroundColor))
//
//      // Draw the text
//      context.draw(resolver, in: textRect)
    }
  }
}

// Extension to make it easier to use
extension View {
  public func angledLine(
    from point1: CGPoint, to point2: CGPoint,
    lineColor: Color = .blue,
    textColor: Color = .white,
    textBackgroundColor: Color = .black.opacity(0.7),
    lineWidth: CGFloat = 2
  ) -> some View {
    self.modifier(
      AngleLineModifier(
        point1: point1,
        point2: point2,
        lineColor: lineColor,
        textColor: textColor,
        textBackgroundColor: textBackgroundColor,
        lineWidth: lineWidth
      ))
  }
}

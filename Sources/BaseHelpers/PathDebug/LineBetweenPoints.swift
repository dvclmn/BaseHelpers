//
//  LineBtweenPoints.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 10/5/2025.
//

import SwiftUI

public struct AngledLineConfig {
  var p1: CGPoint
  var p2: CGPoint
  var lineColour: Color = .blue
  var lineWidth: CGFloat = 2
  var textColour: Color = .white
  var textBackgroundColour: Color = .black.opacity(0.7)
}

public struct AngleLineModifier: ViewModifier {
  let config: AngledLineConfig

  public func body(content: Content) -> some View {
    content
      .overlay(AngleLineView(config: config))
  }
}

public struct AngleLineView: View {
  
  let config: AngledLineConfig

//  private var angle: Double {
//    /// Calculate angle (counterclockwise from positive x-axis)
//    let deltaX = point2.x - point1.x
//    let deltaY = point2.y - point1.y
//
//    return atan2(deltaY, deltaX)
//  }

  

  public var body: some View {
    Canvas {
      context,
      size in
      /// Draw line between the two points
      let path = Path { path in
        path.move(to: config.p1)
        path.addLine(to: config.p2)
      }
      
      context.stroke(
        path,
        with: .color(config.lineColour),
        lineWidth: config.lineWidth
      )

//      // Create the text to display
//      let degreesText = String(format: "%.1f°", angleInDegrees)
//      let radiansText = String(format: "%.2f rad", angle)
//      let angleText = "\(degreesText)\n\(radiansText)"
//
//      // Create text resolver to get text dimensions
//      let resolver = context.resolve(
//        Text(angleText)
//          .font(.system(size: 12))
//          .foregroundColor(textColour)
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
//      context.fill(backgroundPath, with: .color(textBackgroundColour))
//
//      // Draw the text
//      context.draw(resolver, in: textRect)
    }
    .overlay {
      Text(CGPoint.angleBetween(config.p1, config.p2).displayString)
        .position(CGPoint.midPoint(from: config.p1, to: config.p2))
    }
  }
}

extension View {
  public func angledLine(
    from point1: CGPoint, to point2: CGPoint,
    lineColour: Color = .blue,
    lineWidth: CGFloat = 2,
    textColour: Color = .white,
    textBackgroundColour: Color = .black.opacity(0.7),
  ) -> some View {
    self.modifier(
      AngleLineModifier(
        config: AngledLineConfig(
          p1: point1,
          p2: point2,
          lineColour: lineColour,
          lineWidth: lineWidth,
          textColour: textColour,
          textBackgroundColour: textBackgroundColour
        )
      )
    )
  }
}

import SwiftUI

public struct ExampleLineBetweenView: View {
  
  let p1: CGPoint = .init(x: 200, y: 300)
  let p2: CGPoint = .init(x: 400, y: 600)
  
  public var body: some View {
    
    Text("Hello")
    .frame(width: 600, height: 700)
    .angledLine(from: p1, to: p2)
    
  }
}
#if DEBUG
#Preview{
  ExampleLineBetweenView()
}
#endif


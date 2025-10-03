//
//  MessageBubble.swift
//  Components
//
//  Created by Dave Coleman on 11/2/2025.
//

import SwiftUI
import BaseHelpers

public struct MessageBubbleShape: Shape {

//  let height: CGFloat
//  let width: CGFloat
//  let rightOffset: CGFloat

  public init(
//    height: CGFloat,
//    width: CGFloat
//    rightOffset: CGFloat
  ) {
//    self.height = height
//    self.width = width
//    self.rightOffset = rightOffset
  }

  public func path(in rect: CGRect) -> Path {
    var path = Path()

//    guard points.count > 1 else {
//      return path
//    }

    let width: CGFloat = 100
    let height: CGFloat = 200

    let diagonalThing: CGFloat = 50

//    let insetRight: CGFloat = 10

    let shapeOriginY: CGFloat = 0
    let shapeOriginX: CGFloat = rect.maxX - width

    let rounding: CGFloat = diagonalThing * 0.6

    let start = CGPoint(x: shapeOriginX, y: shapeOriginY)

    let bottomLeft = CGPoint(x: shapeOriginX + diagonalThing, y: height)
    let bottomRight = bottomLeft.shiftedRight(width - (diagonalThing * 2))
//    let bottomRight = bottomLeft.shiftRight(shapeWidth - diagonalThing)
    let topRight = start.shiftedRight(width)

    path.move(to: start)

    path.addCurve(to: bottomLeft, control1: start.shiftedRight(rounding), control2: bottomLeft.shiftedLeft(rounding))

    path.addLine(to: bottomRight)
//    path.addLine(to: topRight)

    path.addCurve(
      to: topRight,
      control1: bottomRight.shiftedRight(rounding),
      control2: topRight.shiftedLeft(rounding)
    )
//    for i in 0..<points.count {
//      let currentPoint = points[i]
//      let nextPoint = points[(i + 1) % points.count]
//      let previousPoint = points[(i - 1 + points.count) % points.count]
//
//      if i == 0 {
//        path.move(to: currentPoint)
//      } else {
//        let controlPoint1 = CGPoint(
//          x: previousPoint.x + (currentPoint.x - previousPoint.x) * (1 - cornerRadius),
//          y: previousPoint.y + (currentPoint.y - previousPoint.y) * (1 - cornerRadius)
//        )
//        let controlPoint2 = CGPoint(
//          x: currentPoint.x + (nextPoint.x - currentPoint.x) * cornerRadius,
//          y: currentPoint.y + (nextPoint.y - currentPoint.y) * cornerRadius
//        )
//
//        path.addCurve(to: controlPoint2, control1: controlPoint1, control2: currentPoint)
//      }
//    }

    path.closeSubpath()
    return path
  }
}


struct MessageBubbleView: View {
  
  var body: some View {
    
    MessageBubbleShape()
      .fill(.purple)
    
  }
}
#if DEBUG
@available(macOS 15, iOS 18, *)
#Preview {
  MessageBubbleView()
}
#endif


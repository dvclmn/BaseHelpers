//
//  File.swift
//
//
//  Created by Dave Coleman on 26/7/2024.
//

import SwiftUI
import BaseHelpers
import Shortcuts
//import BaseComponents

extension Resizable {
  
  @ViewBuilder
  func Grabber() -> some View {
    
    var calculatedGrabArea: Double {
      grabArea * grabAreaOuterPercentage
    }
    
    var offset: CGSize {
      switch edge {
        case .top:
          CGSize(width: 0, height: calculatedGrabArea * -1)
        case .bottom:
          CGSize(width: 0, height: calculatedGrabArea)
        case .leading:
          CGSize(width: calculatedGrabArea * -1, height: 0)
        case .trailing:
          CGSize(width: calculatedGrabArea, height: 0)
      }
      
    }
    
    
    Color.clear
//    Color.blue.opacity(0.3)
      .frame(
        width: edge.axis == .horizontal ? grabArea : nil,
        height: edge.axis == .vertical ? grabArea : nil
      )
      .ignoresSafeArea()
      .background(.blue.opacity( isShowingFrames ? 0.2 : 0))
      .contentShape(Rectangle())
      .debouncedHover(seconds: 0.1) { hovering in
        withAnimation(isAnimated ? animation : nil) {
          isHoveringLocal = hovering
        }
      }
//      .onHover { hovering in
//        withAnimation(isAnimated ? animation : nil) {
//          isHoveringLocal = hovering
//        }
//      }
      .offset(offset)
      .background(alignment: edge.alignment) {
        
//        ShapeDebug {
//          CustomRoundedShape()
//        }
        
          
        
        handleColour.opacity(grabberOpacity)
          .frame(
            minWidth: edge.axis == .horizontal ? handleSize : nil,
            maxWidth: edge.axis == .horizontal ? handleSize : .infinity,
            minHeight: edge.axis == .vertical ? handleSize : nil,
            maxHeight: edge.axis == .vertical ? handleSize : .infinity
          )
      }
      
    
    
    
  }
  
  var grabberOpacity: Double {
    
    let baseOpacity: Double = 0.09
    let emphasisedOpacity: Double = 0.14
    
    if isManualMode {
      
      if isHoveringLocal {
        if handleVisibleWhenResized {
          return emphasisedOpacity
        } else {
          return baseOpacity
        }
      } else {
        if handleVisibleWhenResized {
          return baseOpacity
        } else if isResizing {
          return baseOpacity
        } else {
          return 0
        }
      }
      
    } else {
      
      if isHoveringLocal {
        return baseOpacity
      } else {
        return 0
      }
      
    }
  }
}




struct CustomRoundedShape: Shape {
  
  func path(in rect: CGRect) -> Path {
    var path = Path()
    
//    guard points.count > 1 else {
//      return path
//    }
    
    
    let shapeHeight: CGFloat = 30
    let shapeWidth: CGFloat = 120
    let diagonalThing: CGFloat = 40
    
    let shapeOriginY: CGFloat = 0
    let shapeOriginX: CGFloat = 10
    
    let rounding: CGFloat = diagonalThing * 0.6
    
    let start = CGPoint(x: shapeOriginX, y: shapeOriginY)
    
    let bottomLeft = CGPoint(x: shapeOriginX + diagonalThing, y: shapeHeight)
    let bottomRight = CGPoint(x: shapeWidth - diagonalThing, y: shapeHeight)
    let topRight = CGPoint(x: shapeWidth, y: shapeOriginY)
    
    path.move(to: start)
    path.addLine(to: bottomLeft)
    path.addLine(to: bottomRight)
//    path.addLine(to: topRight)
    
    path.addCurve(
      to: topRight,
      control1: bottomRight.shiftRight(rounding),
      control2: topRight.shiftLeft(rounding)
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


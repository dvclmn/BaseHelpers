//
//  HoverEffect.swift
//  Collection
//
//  Created by Dave Coleman on 12/11/2024.
//

import SwiftUI

public struct Hover3DModifier: ViewModifier {
  
  @State var isHovering: Bool = false
  @State var hoverPoint: CGPoint = .zero
  
  let viewSize: CGSize
  
  public init(
    viewSize: CGSize
  ) {
    self.viewSize = viewSize
  }
  
  public func body(content: Content) -> some View {
    content
      .overlay {
        if isHovering {
          Rectangle()
            .fill()
            .frame(width: 10, height: 300)
            .rotationEffect(.degrees(30))
            .blur(radius: 26)
            .frame(width: 10)
            .opacity(isPropertyActive ? 0.1 : 0.3)
            .position(hoverPoint)
        }
      }
      .clipShape(.rect(cornerRadius: Styles.sizeSmall))
    //#if DEBUG
    //      .overlay {
    //        DebugText()
    //      }
    //#endif
    
      .rotation3DEffect(
        Angle(degrees: calculateRotationAngle()),
        axis: (
          x: funAngle(.horizontal),
          y: funAngle(.vertical),
          z: 0
        ),
        anchor: .center,
        anchorZ: 0
      )
    
      .onContinuousHover { phase in
        withAnimation(Styles.animationSpringSubtle) {
          switch phase {
            case .active(let point):
              isHovering = true
              hoverPoint = point
            case .ended:
              isHovering = false
              hoverPoint = viewSize.centrePoint // Reset to center
          }
        }
      }
    
  }
}

extension Hover3DModifier {
  
  func calculateRotationAngle(_ strength: Double = 10) -> Double {
    guard isHovering else { return 0 }
    
    let normalizedPoint = setAnchorToMiddle(hoverPoint)
    
    /// Calculate the distance from center to determine rotation intensity
    let distance = sqrt(pow(normalizedPoint.x, 2) + pow(normalizedPoint.y, 2))
    
    /// Scale the angle based on distance from center
    return distance * strength
  }
  
  
  func funAngle(_ axis: Axis) -> CGFloat {
    guard isHovering else { return .zero }
    
    let normalizedPoint = setAnchorToMiddle(hoverPoint)
    
    switch axis {
      case .horizontal:
        /// Inverted `x` to match natural movement
        return -normalizedPoint.y
      case .vertical:
        return normalizedPoint.x
    }
  }
  
  
  func setAnchorToMiddle(_ point: CGPoint) -> CGPoint {
    
    /// Convert from top-left origin to center origin by subtracting half the view size
    /// This will result in values from -1 to 1 relative to the center
    
    guard viewSize.isPositive else { return .zero }
    
    let halfWidth = viewSize.width / 2
    
    let normalizedX = (point.x - halfWidth) / halfWidth
    let normalizedY = (point.y - halfWidth) / halfWidth
    
    return CGPoint(x: normalizedX, y: normalizedY)
  }
  
  @ViewBuilder
  func DebugText() -> some View {
            VStack {
              Text("X: \(setAnchorToMiddle(hoverPoint).x.toDecimal())")
              Text("Y:\(setAnchorToMiddle(hoverPoint).y.toDecimal())")
              Text("Width: \(viewSize.width.toDecimal())")
              Text("Height: \(viewSize.height.toDecimal())")
            }
            .font(.callout)
            .padding(4)
            .monospacedDigit()
            .background(.black.opacity(0.6))
  }
}

public extension View {
  func hover3DEffect(viewSize: CGSize) -> some View {
    self.modifier(Hover3DModifier(viewSize: viewSize))
  }
}

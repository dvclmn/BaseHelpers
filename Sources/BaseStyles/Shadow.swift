//
//  File.swift
//
//
//  Created by Dave Coleman on 30/4/2024.
//

import Foundation
import SwiftUI


public struct ShadowDepth {
  var rounding: CGFloat
  var distance: CGFloat
  
  public init(rounding: CGFloat, distance: CGFloat) {
    self.rounding = rounding
    self.distance = distance
  }
}

public struct ShadowModifier: ViewModifier {
  
  var opacity: Double
  var radius: Double
  var distanceY: Double
  var depth: ShadowDepth?
  
  public func body(content: Content) -> some View {
    
    content
      .modifier(LayeredShadow(opacity: opacity, radius: radius, distanceY: distanceY, isOn: !hasDepth))
    
      .background {
        if let depth = depth, opacity > 0.0 {
          RoundedRectangle(cornerRadius: depth.rounding)
            .fill(.ultraThinMaterial)
            .modifier(LayeredShadow(opacity: opacity, radius: radius, distanceY: distanceY, isOn: hasDepth))
            .scaleEffect(min(1.0, max(0.0, depth.distance)))
        }
        
        
      }
  }
  
}

public struct LayeredShadow: ViewModifier {
  
  var opacity: Double
  var radius: Double
  var distanceY: Double
  var isOn: Bool
  
  public func body(content: Content) -> some View {
    content
      .shadow(color: .black.opacity(isOn ? opacity : 0), radius: radius * 0.5, x: 0, y: 2)
      .shadow(color: .black.opacity(isOn ? opacity * 0.5 : 0), radius: radius * 0.7, x: 0, y: max(1, (distanceY / 2)))
      .shadow(color: .black.opacity(isOn ? opacity : 0), radius: radius * 2, x: 0, y: distanceY)
  }
}


extension ShadowModifier {
  var hasDepth: Bool {
    self.depth != nil
  }
}


public extension View {
  func customShadow(
    opacity: Double = 0.2,
    radius: Double = 4,
    distanceY: Double = 6,
    depth: ShadowDepth? = nil
  ) -> some View {
    self.modifier(ShadowModifier(
      opacity: opacity,
      radius: radius,
      distanceY: distanceY,
      depth: depth
    ))
  }
}



private struct ShadowExampleView: View {
  
  var body: some View {
    
    VStack(spacing: 90) {
      
      
      RoundedRectangle(cornerRadius: 20)
        .fill(.ultraThinMaterial)
        .aspectRatio(3.1, contentMode: .fit)
        .frame(width: 380)
        .overlay {
          Text("Opacity Zero")
            .font(.system(size: 15, weight: .medium))
        }
        .customShadow(opacity: 0.0, radius: 16, distanceY: 40, depth: ShadowDepth(rounding: 20, distance: 0.9))
      
      
      
      RoundedRectangle(cornerRadius: 20)
        .fill(.ultraThinMaterial)
        .aspectRatio(3.1, contentMode: .fit)
        .frame(width: 380)
        .overlay {
          Text("Depth effect ON")
            .font(.system(size: 15, weight: .medium))
        }
        .customShadow(opacity: 0.9, radius: 16, distanceY: 40, depth: ShadowDepth(rounding: 20, distance: 0.9))
      
        .padding(.bottom, 40)
      
      
      RoundedRectangle(cornerRadius: 20)
        .fill(.gray)
        .aspectRatio(3.1, contentMode: .fit)
        .frame(width: 380)
        .customShadow(opacity: 0.7, radius: 16, distanceY: 50)
        .overlay {
          Text("Depth effect OFF")
            .font(.system(size: 15, weight: .medium))
        }
      
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(38)
    .background(.teal.opacity(0.2))
    
  }
}

#Preview {
  ShadowExampleView()
    .frame(width: 600, height: 700)
}






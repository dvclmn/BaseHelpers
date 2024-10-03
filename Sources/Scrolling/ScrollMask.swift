//
//  File.swift
//
//
//  Created by Dave Coleman on 26/6/2024.
//

import Foundation
import SwiftUI
import SmoothGradient

public struct ScrollMask: ViewModifier {
  
  var scrollOffset: CGFloat
  var maskMode: MaskMode
  var edge: Edge
  var length: CGFloat
  
  public func body(content: Content) -> some View {
    
    switch maskMode {
      case .mask:
        content
          .overlay {
//          .mask {
            MaskEffect()
              .allowsHitTesting(false)
          }
          .ignoresSafeArea()
      case .overlay:
        content
          .overlay {
            MaskEffect()
              .blendMode(.multiply)
              .allowsHitTesting(false)
          }
      case .off:
        content
    }
    
  }
  
  @ViewBuilder
  func MaskEffect() -> some View {
    
    switch edge {
      case .top:
        VStack(spacing: 0) {
          MaskGradient()
          MaskBlock()
        }
        .frame(maxHeight: .infinity, alignment: .top)
        
        
      case .leading:
        HStack(spacing: 0) {
          MaskGradient()
          MaskBlock()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
        
      case .bottom:
        VStack(spacing: 0) {
          MaskBlock()
          MaskGradient()
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        
        
      case .trailing:
        HStack(spacing: 0) {
          MaskBlock()
          MaskGradient()
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        
    }
    
  }
  
  @ViewBuilder
  func MaskBlock() -> some View {
    if maskMode == .mask {
      Rectangle()
        .fill(.black)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
  }
  
  @ViewBuilder
  func MaskGradient() -> some View {
    
    ZStack {
      LinearGradient(
        colors: [
          .black.opacity(startOpacity),
          .black.opacity(endOpacity)
        ],
        startPoint: edge.off,
        endPoint: edge.on
      )
      LinearGradient(
        colors: [
          .black.opacity(startOpacity),
          .black.opacity(endOpacity)
        ],
        startPoint: edge.off,
        endPoint: edge.onQuarter
//        endPoint: isEffectActive ? edge.onQuarter : edge.off
      )
    }
    
    //        .frame(
    //            width: abs(edge.axis == .horizontal ? length : .infinity),
    //            height: abs(edge.axis == .vertical ? length : .infinity)
    //        )
    
    .frame(
      maxWidth: abs(edge.axis == .horizontal ? length : .infinity),
      maxHeight: abs(edge.axis == .vertical ? length : .infinity),
      alignment: edge.alignment
    )
    //        .padding(Edge.Set(edge), offset)
    
    
  }
}

extension ScrollMask {
  
  
  private func normalizeScrollOffset(_ offset: CGFloat) -> CGFloat {
    guard length > 0 else { return 0 }
    return min(max(offset / length, 0), 1)
  }
  
  var startOpacity: CGFloat {
    switch maskMode {
      case .mask:
        /// Starting at fully transparent means the content will be completely
        /// faded out at the top, and fade in as it goes down
        return (-1 * normalizeScrollOffset(scrollOffset))
      case .overlay:
        /// This is the opposite
        return min(maskMode.opacity, normalizeScrollOffset(scrollOffset))
//        return isEffectActive ? opacity : 0.0
        
      case .off:
        return 1.0
        
    }
  }
  
  var endOpacity: CGFloat {
    switch maskMode {
      case .mask:
        return 1.0
      case .overlay:
        return 0.0
        
      case .off:
        return 1.0
    }
  }
  
}

public extension View {
  func scrollMask(
    scrollOffset: CGFloat,
    maskMode: MaskMode = .mask,
    edge: Edge = .top,
    length: CGFloat = 130
  
  ) -> some View {
    self.modifier(
      ScrollMask(
        scrollOffset: scrollOffset,
        maskMode: maskMode,
        edge: edge,
        length: length
      )
    )
  }
}

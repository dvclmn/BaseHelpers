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
  
  var offset: CGFloat
  
  var maskMode: MaskMode
  
  var edge: Edge
  
  var opacity: CGFloat
  var length: CGFloat
  
  private let maxOffset: CGFloat = 200
  
  public func body(content: Content) -> some View {
    
    switch maskMode {
      case .mask:
        content
          .mask {
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
    }
    
  }
  
  @ViewBuilder
  func MaskEffect() -> some View {
    
    switch edge {
      case .top:
        VStack(spacing: 0) {
          MaskGradient(opacity: opacity)
          MaskBlock()
        }
        .frame(maxHeight: .infinity, alignment: .top)
        
        
      case .leading:
        HStack(spacing: 0) {
          MaskGradient(opacity: opacity)
          MaskBlock()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
        
      case .bottom:
        VStack(spacing: 0) {
          MaskBlock()
          MaskGradient(opacity: opacity)
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        
        
      case .trailing:
        HStack(spacing: 0) {
          MaskBlock()
          MaskGradient(opacity: opacity)
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
  func MaskGradient(opacity: CGFloat) -> some View {
    
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
  
  
  private func normalizeScrollOffset(_ offset: CGFloat, maxOffset: CGFloat) -> CGFloat {
    guard maxOffset > 0 else { return 0 }
    return min(max(offset / maxOffset, 0), 1)
  }
  
  var startOpacity: CGFloat {
    switch maskMode {
      case .mask:
        /// Starting at fully transparent means the content will be completely
        /// faded out at the top, and fade in as it goes down
        return (-1 * normalizeScrollOffset(offset, maxOffset: maxOffset))
      case .overlay:
        /// This is the opposite
        return min(opacity, normalizeScrollOffset(offset, maxOffset: maxOffset))
//        return isEffectActive ? opacity : 0.0
        
    }
  }
  
  var endOpacity: CGFloat {
    switch maskMode {
      case .mask:
        return 1.0
      case .overlay:
        return 0.0
    }
  }
  
}

public extension View {
  func scrollMask(
    offset: CGFloat,
    //        _ isEffectActive: Bool,
    maskMode: MaskMode = .mask,
    edge: Edge = .top,
    opacity: CGFloat = 0.2,
    length: CGFloat = 130
    //        offset: CGFloat = .zero
  ) -> some View {
    self.modifier(
      ScrollMask(
//        isEffectActive: isEffectActive,
        offset: offset,
        maskMode: maskMode,
        edge: edge,
        opacity: opacity,
        length: length
      )
    )
  }
}

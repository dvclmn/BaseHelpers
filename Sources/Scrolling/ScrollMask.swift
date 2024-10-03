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
  var edgePadding: CGFloat
  var length: CGFloat
  
  public func body(content: Content) -> some View {
    
    switch maskMode {
      case .mask:
        content
          .safeAreaPadding(edge.edgeSet, edgePadding)
          .overlay {
//          .mask {
            MaskEffect()
              .allowsHitTesting(false)
          }
//          .ignoresSafeArea()
      case .overlay:
        content
          .safeAreaPadding(edge.edgeSet, edgePadding)
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
    Rectangle()
      .fill(.cyan.opacity(0.1))
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .ignoresSafeArea()

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
      .frame(maxWidth: .infinity, maxHeight: .infinity)
//      .border(Color.orange.opacity(0.3))
      
      /// This double-up looks nice for the overlay mode (smooths out gradient steps),
      /// but causes mask to hide too much of the view, in mask mode.
      
      if maskMode == .overlay() {
      
        LinearGradient(
          colors: [
            .black.opacity(startOpacity),
            .black.opacity(endOpacity)
          ],
          startPoint: edge.off,
          endPoint: edge.onQuarter
  //        endPoint: isEffectActive ? edge.onQuarter : edge.off
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      }

    }
    
    //        .frame(
    //            width: abs(edge.axis == .horizontal ? length : .infinity),
    //            height: abs(edge.axis == .vertical ? length : .infinity)
    //        )
    
    .frame(
      width: edge.axis == .horizontal ? max(0, length) : nil,
      height: edge.axis == .vertical ? max(0, length) : nil,
      alignment: edge.alignment
    )
    
//    .frame(
//      maxWidth: abs(edge.axis == .horizontal ? length : .infinity),
//      maxHeight: abs(edge.axis == .vertical ? length : .infinity),
//      alignment: edge.alignment
//    )
    //        .padding(Edge.Set(edge), offset)
    
    
  }
}

extension ScrollMask {
  
  
  private func normalizeScrollOffset(_ offset: CGFloat, inverted: Bool = false) -> CGFloat {
    
    
    guard edgePadding > 0 else { return 0 }
    
    let result = min(max(offset / edgePadding, 0), 1)
    
    if maskMode == .mask {
      print("Scroll Offset: \(offset)")
      print("Edge padding: \(edgePadding)")
      print("Normalised: \(result)")
    }
    
    return inverted ? 1.0 - result : result
  }
  
  var startOpacity: CGFloat {
    switch maskMode {
      case .mask:
        /// Starting at fully transparent means the content will be completely
        /// faded out at the top, and fade in as it goes down
        return normalizeScrollOffset(scrollOffset, inverted: true)
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
        
        /// The end value for mask-mode's opacity is `1,0`, because the
        /// masking is based on *alpha values*. Ensuring the opacity ends up at
        /// `1.0`, means the bulk of the scroll content will be covered by opaque
        /// value, and thus visible.
      case .mask:
        return 1.0
        
        /// The opacity ends at `0` for overlay, to allow the content to
        /// show through. Overlay is a little easier (for me) to understand,
        /// as it corresponds to the more typical idea of 'opacity' (like the
        /// opacity slider in Photoshop). Big number (`1.0`) is more visible,
        /// little number (`0.0`) is less visible.
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
    edgePadding: CGFloat = 20,
    length: CGFloat = 130
  
  ) -> some View {
    self.modifier(
      ScrollMask(
        scrollOffset: scrollOffset,
        maskMode: maskMode,
        edge: edge,
        edgePadding: edgePadding,
        length: length
      )
    )
  }
}

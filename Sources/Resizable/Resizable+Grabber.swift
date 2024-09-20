//
//  File.swift
//
//
//  Created by Dave Coleman on 26/7/2024.
//

import SwiftUI
import BaseHelpers

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
      .onHover { hovering in
        withAnimation(isAnimated ? animation : nil) {
          isHoveringLocal = hovering
        }
      }
      .offset(offset)
      .background(alignment: edge.alignment) {
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

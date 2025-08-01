//
//  FrameFromUnitPointModifier.swift
//  BaseComponents
//
//  Created by Dave Coleman on 30/7/2025.
//

import SwiftUI

public struct HitAreaRectModifier: ViewModifier {
  @State private var containerSize: CGSize = .zero

  let unitPoint: UnitPoint
  let thickness: CGFloat
  let offset: RectBoundaryPlacement
  let colour: Color

  public func body(content: Content) -> some View {
    content
      .frame(
        width: hitArea.size.width,
        height: hitArea.size.height
      )
      .background(colour)
      .frame(
        maxWidth: .infinity,
        maxHeight: .infinity,
        alignment: hitArea.alignment
      )
      .offset(rectOffset)
      .viewSize(mode: .noDebounce) { size in
        containerSize = size
      }
  }
}
extension HitAreaRectModifier {
  
  var rectOffset: CGSize {
    switch offset {
        
      case .inside:
        return unitPoint.offset(by: thickness / 2)
        
      case .outside:
        return unitPoint.offset(by: -thickness)
        
        /// I think this is default behaviour
      case .centre: return .zero
        
    }
  }
  
  var hitArea: HitAreaLayout {
    return HitAreaLayout(
      from: unitPoint,
      container: containerSize,
      thickness: thickness
    )
  }
}

extension View {

  public func hitAreaRect(
    unitPoint: UnitPoint,
    thickness: CGFloat,
    offset: RectBoundaryPlacement = .centre,
    colour: Color = .blue
  ) -> some View {
    self.modifier(
      HitAreaRectModifier(
        unitPoint: unitPoint,
        thickness: thickness,
        offset: offset,
        colour: colour
      )
    )
  }
}

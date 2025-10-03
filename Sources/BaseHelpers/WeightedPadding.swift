//
//  WeightedPadding.swift
//  BaseStyles
//
//  Created by Dave Coleman on 2/3/2025.
//

import SwiftUI

public struct WeightedPaddingModifier: ViewModifier {
  let padding: CGFloat
  let horizontalBias: CGFloat
  let edge: Edge?
  
  public init(
    padding: CGFloat,
    horizontalBias: CGFloat,
    edge: Edge?
  ) {
    self.padding = padding
    self.horizontalBias = horizontalBias
    self.edge = edge
  }
  
  public func body(content: Content) -> some View {
    content
      .safeAreaPadding(.top, adjustedPadding.top)
      .safeAreaPadding(.bottom, adjustedPadding.bottom)
      .safeAreaPadding(.leading, adjustedPadding.leading)
      .safeAreaPadding(.trailing, adjustedPadding.trailing)
  }
}

extension WeightedPaddingModifier {
  var adjustedPadding: (top: CGFloat, bottom: CGFloat, leading: CGFloat, trailing: CGFloat) {
    /// Calculate vertical padding - always the base padding value
    let verticalPadding = padding
    
    /// Calculate horizontal padding with bias applied directly
    /// This way horizontalBias represents a direct multiplier
    let horizontalPadding = padding * horizontalBias
    
    guard let edge else {
      /// Apply full padding to all edges when no edge is excluded
      return (verticalPadding, verticalPadding, horizontalPadding, horizontalPadding)
    }
    
    switch edge {
      case .top:
        return (0, verticalPadding, horizontalPadding, horizontalPadding)
        
      case .bottom:
        return (verticalPadding, 0, horizontalPadding, horizontalPadding)
        
      case .leading:
        return (verticalPadding, verticalPadding, 0, horizontalPadding)
        
      case .trailing:
        return (verticalPadding, verticalPadding, horizontalPadding, 0)
    }
  }
}

extension View {
  public func weightedPadding(
    _ padding: CGFloat,
    horizontalBias: CGFloat = 1.4,
    excludeEdge edge: Edge? = nil
  ) -> some View {
    self.modifier(
      WeightedPaddingModifier(
        padding: padding,
        horizontalBias: horizontalBias,
        edge: edge
      )
    )
  }
}

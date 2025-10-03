//
//  CentredRect.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 22/7/2025.
//

import Foundation

extension CGSize {

  /// Creates a CGRect for this size positioned within the given container size
  /// - Parameters:
  ///   - containerSize: The size of the container view
  ///   - strategy: How to handle cases where this size is larger than the container
  /// - Returns: A CGRect positioned according to the strategy, or nil if strategy is failIfOversized and view is too large
  public func toCGRect(
    in containerSize: CGSize,
    strategy: PlacementStrategy = .centerWithOverflow
  ) -> CGRect {
    
    switch strategy {
        
      case .centerWithOverflow:
        return centeredRect(in: containerSize, with: self)
        
      case .scaleToFit:
        let scaledSize = self.aspectFitSize(in: containerSize)
        return centeredRect(in: containerSize, with: scaledSize)
        
      case .scaleToFill:
        let scaledSize = self.aspectFillSize(in: containerSize)
        return centeredRect(in: containerSize, with: scaledSize)
        
      case .topLeft:
        return CGRect(origin: .zero, size: self)
        
      case .topRight:
        return CGRect(
          x: containerSize.width - width,
          y: 0,
          width: width,
          height: height
        )
        
      case .bottomLeft:
        return CGRect(
          x: 0,
          y: containerSize.height - height,
          width: width,
          height: height
        )
        
      case .bottomRight:
        return CGRect(
          x: containerSize.width - width,
          y: containerSize.height - height,
          width: width,
          height: height
        )
    }
  }

  private func centeredRect(
    in containerSize: CGSize,
    with size: CGSize
  ) -> CGRect {
    let x = (containerSize.width - size.width) / 2
    let y = (containerSize.height - size.height) / 2
    return CGRect(x: x, y: y, width: size.width, height: size.height)
  }
  
  private func aspectFitSize(in containerSize: CGSize) -> CGSize {
    let widthRatio = containerSize.width / width
    let heightRatio = containerSize.height / height
    let scale = min(widthRatio, heightRatio)
    
    return CGSize(width: width * scale, height: height * scale)
  }
  
  private func aspectFillSize(in containerSize: CGSize) -> CGSize {
    let widthRatio = containerSize.width / width
    let heightRatio = containerSize.height / height
    let scale = max(widthRatio, heightRatio)
    
    return CGSize(width: width * scale, height: height * scale)
  }
  
}

extension CGSize {
  /// Strategy for handling views that are larger than their container
  public enum PlacementStrategy {
    /// Center the view within the container, allowing overflow
    case centerWithOverflow
    /// Scale the view proportionally to fit within the container
    case scaleToFit
    /// Scale the view to fill the container, potentially cropping content
    case scaleToFill
    /// Align to top-left corner, allowing overflow
    case topLeft
    /// Align to top-right corner, allowing overflow
    case topRight
    /// Align to bottom-left corner, allowing overflow
    case bottomLeft
    /// Align to bottom-right corner, allowing overflow
    case bottomRight
    /// Return nil if the view doesn't fit (original behavior)
  }
  
}

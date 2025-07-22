//
//  CGSize.swift
//  Collection
//
//  Created by Dave Coleman on 12/11/2024.
//

import Foundation
import SwiftUI

extension CGSize {

  // MARK: - Initialisers

  public init(fromLength length: CGFloat) {
    self.init(width: length, height: length)
  }

  public init(_ width: CGFloat, _ height: CGFloat) {
    self.init(width: width, height: height)
  }

  // MARK: - Conversions

  public var toCGRectZeroOrigin: CGRect {
    CGRect(origin: .zero, size: self)
  }

  public var toCGPoint: CGPoint {
    CGPoint(x: width, y: height)
  }

  // MARK: - General

  public var halved: CGSize {
    return CGSize(width: width / 2, height: height / 2)
  }

  public var longestDimension: CGFloat {
    return max(width, height)
  }
  public var shortestDimension: CGFloat {
    return min(width, height)
  }

  public func value(for axis: Axis) -> CGFloat {
    switch axis {
      case .horizontal: width
      case .vertical: height
    }
  }

  /// Returns a new size reduced evenly on all four sides by the specified inset value, and clamped to min value of `0`.
  /// - Parameter inset: The amount to inset from all edges. Width and height are each reduced by 2x this value, 1x for each opposing side
  /// - Returns: A new CGSize with the inset applied
  public func inset(by inset: CGFloat) -> CGSize {
    return CGSize(
      width: max(0, width - (inset * 2)),
      height: max(0, height - (inset * 2))
    )
  }

  /// Returns the centre point of the size
  public var midpoint: CGPoint {
    return CGPoint(x: width / 2, y: height / 2)
  }

  public func aspectRatio(
    mode: ResizeMode,
    intoSize size: CGSize
  ) -> CGSize {
    if self == .zero {
      return self
    }

    let widthRatio = size.width / self.width
    let heightRatio = size.height / self.height
    
    let ratio:CGFloat = switch mode {
        case .fit: min(widthRatio, heightRatio)
 case .fill: max(widthRatio, heightRatio)
      case .stretch: size
    }
    
    return CGSize(
      width: self.width * ratio,
      height: self.height * ratio
    )
  }

//  public func aspectRatioFill(into size: CGSize) -> CGSize {
//    if self == .zero {
//      return self
//    }
//
//    let widthRatio = size.width / self.width
//    let heightRatio = size.height / self.height
//    let aspectFillRatio = max(widthRatio, heightRatio)
//    return CGSize(
//      width: self.width * aspectFillRatio,
//      height: self.height * aspectFillRatio
//    )
//  }
  

  // MARK: - Comparisons
  /// Returns true if both width and height are greater than zero
  public var isGreaterThanZero: Bool {
    width > 0 && height > 0
  }

  /// Returns true if both width and height are greater than or equal to zero
  public var isGreaterThanOrEqualToZero: Bool {
    width >= 0 && height >= 0
  }

  /// Returns true if either width or height is zero or negative
  public var isLessThanOrEqualToZero: Bool {
    !isGreaterThanZero
  }

  public var hasValidValue: Bool {
    return !isNan && isFinite
  }

  // MARK: - > Greater Than
  public func isAnyDimensionGreaterThan(_ value: CGFloat) -> Bool {
    return width > value || height > value
  }

  public func isAnyDimensionGreaterThanOrEqualTo(_ value: CGFloat) -> Bool {
    return width >= value || height >= value
  }

  public func areBothDimensionsGreaterThan(_ value: CGFloat) -> Bool {
    return width > value && height > value
  }

  public func areBothDimensionsGreaterThanOrEqualTo(_ value: CGFloat) -> Bool {
    return width >= value && height >= value
  }

  // MARK: - < Less Than
  public func isAnyDimensionLessThan(_ value: CGFloat) -> Bool {
    return width < value || height < value
  }

  public func isAnyDimensionLessThanOrEqualTo(_ value: CGFloat) -> Bool {
    return width <= value || height <= value
  }

  public func areBothDimensionsLessThan(_ value: CGFloat) -> Bool {
    return width < value && height < value
  }

  public func areBothDimensionsLessThanOrEqualTo(_ value: CGFloat) -> Bool {
    return width <= value && height <= value
  }

  /// Returns true if both dimensions are finite
  public var isFinite: Bool {
    width.isFinite && height.isFinite
  }

  /// Returns true if either dimension is NaN
  public var isNan: Bool {
    return width.isNaN || height.isNaN
  }

  public var widthOrHeightIsZero: Bool {
    self.width.isZero || self.height.isZero
  }

  // MARK: - Zoom
  public func removingZoom(_ zoom: CGFloat) -> CGSize {
    return self / zoom
  }

  func removingZoomPercent(_ zoomPercent: CGFloat) -> CGSize {
    let adjustedWidth = self.width.removingZoomPercent(zoomPercent)
    let adjustedHeight = self.height.removingZoomPercent(zoomPercent)
    return CGSize(width: adjustedWidth, height: adjustedHeight)
  }

}

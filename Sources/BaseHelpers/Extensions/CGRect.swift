//
//  CGRect.swift
//  Collection
//
//  Created by Dave Coleman on 9/12/2024.
//

import SwiftUI

extension CGRect {
  
  public static let trackpad = CGRect(
    x: 0,
    y: 0,
    width: 700,
    height: 438
  )
  public static let example01 = CGRect(
    x: 0,
    y: 0,
    width: 100,
    height: 100
  )
  
  public var path: Path {
    Path(self)
  }

  /// Returns a CGRect that positions this rect inside the given `viewSize`,
  /// using the provided `anchorPoint` (like `.topLeading`, `.center`, etc.).
  ///
  /// This is useful when you want to align a specific point of your view
  /// (like the topLeading corner) with the given origin in `.position()`.
//  public func positionedIn(
//    viewSize: CGSize,
//    anchorPoint: UnitPoint = .center
//  ) -> CGRect {
//    // Convert UnitPoint (0...1, 0...1) into actual CGPoint in viewSize
//    let anchorInView = CGPoint(
//      x: viewSize.width * anchorPoint.x,
//      y: viewSize.height * anchorPoint.y
//    )
//
//    // Convert UnitPoint into anchor in the rect itself
//    let anchorInSelf = CGPoint(
//      x: self.width * anchorPoint.x,
//      y: self.height * anchorPoint.y
//    )
//
//    // The origin needed to place `self` so its anchor aligns with `anchorInView`
//    let newOrigin = CGPoint(
//      x: anchorInView.x - anchorInSelf.x,
//      y: anchorInView.y - anchorInSelf.y
//    )
//    
////    print("This CGRect's original origin point: \(self.origin.displayString)")
////    print("And new origin point?: \(newOrigin.displayString)")
//
//    return CGRect(origin: newOrigin, size: self.size)
//  }

  /// This can be made better, but got this because SwiftUI's `.position()`
  /// modifier places the *centre* of the view at the origin. If the origin is
  /// meant to be the top leading corner, then this can help compensate for that.
    public func centeredIn(
      viewSize: CGSize,
  //    anchorPoint: UnitPoint = .topLeading,
    ) -> CGRect {
      
      /// We get the width and height (e.g. of a canvas, within a view)
      let rectWidth: CGFloat = self.width
      let rectHeight: CGFloat = self.height
      
      /// Halve it — this should be the rect's midpoint right?
      let rectWidthHalf = rectWidth / 2
      let rectHeightHalf = rectHeight / 2
      
      /// We get the width and height of the containing view and halve *that*
      let viewWidthHalf: CGFloat = viewSize.width / 2
      let viewHeightHalf: CGFloat = viewSize.height / 2
      
      let newOrigin = CGPoint(
        x: viewWidthHalf - rectWidthHalf,
        y: viewHeightHalf - rectHeightHalf
      )

      return CGRect(x: newOrigin.x, y: newOrigin.y, width: rectWidth, height: rectHeight)
    }

  
  
    public func centred(in containerSize: CGSize) -> CGRect {
      let origin = CGPoint(
        x: (containerSize.width - self.width) / 2,
        y: (containerSize.height - self.height) / 2
      )
      return CGRect(origin: origin, size: self.size)
    }

//  public func midPoint(isFlippedForSwiftUI: Bool = true) -> CGPoint {
//    let midX: CGFloat = self.midX
//    let midY: CGFloat = self.midY
//    
//    return CGPoint(x: midX, y: isFlippedForSwiftUI ? (midY * -1) : midY)
//
//  }

  //  public func centred(in viewSize: CGSize) -> CGRect {
  //    let something = size.midpoint
  //    let halfX = self.width / 2
  //    let halfY = self.height / 2
  //
  //    let originalOrigin: CGPoint = self.origin
  //
  //    return CGRect(
  //      origin: .zero,
  //      size: self.size
  //    )
  //
  //  }

  public var toCGSize: CGSize {
    CGSize(width: width, height: height)
  }

  public var displayString: String {
    self.displayString()
  }

  public func displayString(
    decimalPlaces: Int = 2,
    style: DisplayStringStyle = .short
  ) -> String {

    let originX: String = "\(self.origin.x.displayString(decimalPlaces))"
    let originY: String = "\(self.origin.y.displayString(decimalPlaces))"
    let width: String = "\(self.width.displayString(decimalPlaces))"
    let height: String = "\(self.height.displayString(decimalPlaces))"

    switch style {
      case .short, .initials:
        return "X \(originX), Y \(originY), W \(width), H \(height)"

      case .full:
        return "X \(originX), Y \(originY), Width \(width), Height \(height)"
    }
  }

  // Corner points
  public var topLeft: CGPoint {
    CGPoint(x: minX, y: minY)
  }

  public var topRight: CGPoint {
    CGPoint(x: maxX, y: minY)
  }

  public var bottomLeft: CGPoint {
    CGPoint(x: minX, y: maxY)
  }

  public var bottomRight: CGPoint {
    CGPoint(x: maxX, y: maxY)
  }

  public var center: CGPoint {
    CGPoint(x: midX, y: midY)
  }

  // Edges
  public var leftEdge: CGFloat { minX }
  public var rightEdge: CGFloat { maxX }
  public var topEdge: CGFloat { minY }
  public var bottomEdge: CGFloat { maxY }

  // Dimensions
  public var horizontal: ClosedRange<CGFloat> { minX...maxX }
  public var vertical: ClosedRange<CGFloat> { minY...maxY }

  // Initialization helpers
  public static func between(point1: CGPoint, point2: CGPoint) -> CGRect {
    let minX = min(point1.x, point2.x)
    let minY = min(point1.y, point2.y)
    let maxX = max(point1.x, point2.x)
    let maxY = max(point1.y, point2.y)

    return CGRect(
      x: minX,
      y: minY,
      width: maxX - minX,
      height: maxY - minY
    )
  }

  // Useful for selection operations
  public func expanded(toInclude rect: CGRect) -> CGRect {
    let newMinX = min(minX, rect.minX)
    let newMinY = min(minY, rect.minY)
    let newMaxX = max(maxX, rect.maxX)
    let newMaxY = max(maxY, rect.maxY)

    return CGRect(
      x: newMinX,
      y: newMinY,
      width: newMaxX - newMinX,
      height: newMaxY - newMinY
    )
  }
  
  /// Useful for a CGRect that needs to be centered within a View
  init(size: CGSize, centeredIn containerSize: CGSize) {
    let x = (containerSize.width - size.width) / 2
    let y = (containerSize.height - size.height) / 2
    self.init(x: x, y: y, width: size.width, height: size.height)
  }
  
}

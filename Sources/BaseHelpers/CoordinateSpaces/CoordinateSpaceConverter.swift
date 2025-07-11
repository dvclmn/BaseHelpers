//
//  CoordinateSpaceConverter.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 11/7/2025.
//

import SwiftUI

//public struct CoordinateSpaceConverter {
//  
//  /// This whole component is written with the expectation that
//  /// SwiftUI views are center-aligned by default.
//  let layoutAlignment: Alignment = .center
//  let canvasTransform: CanvasTransform
//}

//struct CoordinateConverter {
//  private let transforms: [CoordinateSpaceID: SpaceTransform]
//  
//  let proxy: GeometryProxy
//  
//  init(transforms: [CoordinateSpaceID: SpaceTransform]) {
//    self.transforms = transforms
//  }
//  
//  func something() {
//    proxy.convert(<#T##point: CGPoint##CGPoint#>, from: <#T##CoordinateSpace#>)
//  }
//  
//  func convert(
//    point: CGPoint,
//    from: CoordinateSpaceID,
//    to: CoordinateSpaceID
//  ) -> CGPoint {
//    guard let fromTransform = transforms[from],
//          let toTransform = transforms[to] else {
//      return point // or fatalError
//    }
//    
//    // Convert point to root space (e.g. screen)
//    let pointInRoot = fromTransform.transform(point: point)
//    
//    // Invert the target transform to go from root to destination
//    let invertedTo = toTransform.inverted()
//    
//    return invertedTo.transform(point: pointInRoot)
//  }
//  
//  func convert(rect: CGRect, from: CoordinateSpaceID, to: CoordinateSpaceID) -> CGRect {
//    // Same as above, but for rects
//    guard let fromTransform = transforms[from],
//          let toTransform = transforms[to] else {
//      return rect
//    }
//    
//    let rectInRoot = fromTransform.transform(rect: rect)
//    let invertedTo = toTransform.inverted()
//    return invertedTo.transform(rect: rectInRoot)
//  }
//}
//
//struct SpaceTransform {
//  var scale: CGFloat = 1
//  var rotation: Angle = .zero
//  var translation: CGPoint = .zero
//  
//  func transform(point: CGPoint) -> CGPoint {
//    var p = point
//    
//    // Translate
//    p.x -= translation.x
//    p.y -= translation.y
//    
//    // Rotate
//    let radians = rotation.radians
//    let s = sin(radians)
//    let c = cos(radians)
//    let xRot = p.x * c - p.y * s
//    let yRot = p.x * s + p.y * c
//    p = CGPoint(x: xRot, y: yRot)
//    
//    // Scale
//    p.x /= scale
//    p.y /= scale
//    
//    return p
//  }
//  
//  func transform(rect: CGRect) -> CGRect {
//    // Optional: apply transform to each corner, then compute bounds
//    let corners = [
//      CGPoint(x: rect.minX, y: rect.minY),
//      CGPoint(x: rect.maxX, y: rect.minY),
//      CGPoint(x: rect.maxX, y: rect.maxY),
//      CGPoint(x: rect.minX, y: rect.maxY)
//    ]
//    let transformedCorners = corners.map { transform(point: $0) }
//    let xs = transformedCorners.map { $0.x }
//    let ys = transformedCorners.map { $0.y }
//    return CGRect(
//      x: xs.min() ?? 0,
//      y: ys.min() ?? 0,
//      width: (xs.max() ?? 0) - (xs.min() ?? 0),
//      height: (ys.max() ?? 0) - (ys.min() ?? 0)
//    )
//  }
//}
//
//enum CoordinateSpaceID {
//  case screen
//  case viewport
//  case canvas
//}

//func convertToCanvas(
//  value: CGSize?,
//  viewportSize: CGSize,
//  canvasSize: CGSize
//) -> CGSize? {
//  let canvasOrigin = canvasSize.originInViewport(
//    viewportSize: viewportSize,
//    transform: self
//  )
//  let result = value?.toCanvas(
//    canvasOriginInViewport: canvasOrigin,
//    transform: self
//  )
//  return result
//}
//
//func convertToCanvas(
//  value: CGPoint?,  // Location in viewport
//  viewportSize: CGSize,
//  canvasSize: CGSize
//) -> CGPoint? {
//  let canvasOrigin = canvasSize.originInViewport(
//    viewportSize: viewportSize,
//    transform: self
//  )
//  let result = value?.toCanvas(
//    canvasOriginInViewport: canvasOrigin,
//    transform: self
//  )
//  return result
//  }
//func convertToViewport(
//  pointInCanvas: CGPoint,
//  viewportSize: CGSize,
//  canvasSize: CGSize
//) -> CGPoint? {
//  let canvasOrigin = canvasSize.originInViewport(
//    viewportSize: viewportSize,
//    transform: self
//  )
//  let result = pointInCanvas.toViewportPoint(
//    canvasOriginInViewport: canvasOrigin,
//    transform: self
//  )
//  return result
//  //    let canvasOrigin = viewportSize.midpoint - (canvasSize * zoom).midpoint + pan
//  //    return pointInCanvas * zoom + canvasOrigin
//  }

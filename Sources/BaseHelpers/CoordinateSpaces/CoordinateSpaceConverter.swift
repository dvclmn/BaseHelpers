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
//  init(transforms: [CoordinateSpaceID: SpaceTransform]) {
//    self.transforms = transforms
//  }
//
//  func convert(
//    point: CGPoint,
//    from: CoordinateSpaceID,
//    to: CoordinateSpaceID
//  ) -> CGPoint {
//    guard let fromTransform = transforms[from],
//      let toTransform = transforms[to]
//    else {
//      return point  // or fatalError
//    }
//
//    /// Convert point to root space (e.g. screen)
//    let pointInRoot = fromTransform.transform(point: point)
//
//    /// Invert the target transform to go from root to destination
//    let invertedTo = toTransform.inverted()
//
//    return invertedTo.transform(point: pointInRoot)
//  }
//
//  func convert(rect: CGRect, from: CoordinateSpaceID, to: CoordinateSpaceID) -> CGRect {
//    /// Same as above, but for rects
//    guard let fromTransform = transforms[from],
//      let toTransform = transforms[to]
//    else {
//      return rect
//    }
//
//    let rectInRoot = fromTransform.transform(rect: rect)
//    let invertedTo = toTransform.inverted()
//    return invertedTo.transform(rect: rectInRoot)
//  }
//}



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

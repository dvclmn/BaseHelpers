//
//  GeometryProxy.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 4/7/2025.
//

import SwiftUI

extension GeometryProxy {
  /// Converts from some other coordinate space to the proxy's own
  ///
  /// Usage:
  /// ```
  /// geometry.convert(location, from: .global)
  /// ```
  public func convert(_ point: CGPoint, from coordinateSpace: CoordinateSpace) -> CGPoint {
    let frame = self.frame(in: coordinateSpace)
    let localViewPoint = CGPoint(x: point.x - frame.origin.x, y: point.y - frame.origin.y)

    // Some system bug? Test in iOS 13.4, 13.5, 14.1, 14.5
    if coordinateSpace == .global {
      return point
//      switch (UIDevice.current.systemVersion as NSString).floatValue {
//        case 13.5:
//          return CGPoint(x: localViewPoint.x, y: point.y)
//        case 14.5:
//          return point
//        default: break
//      }
    }

    return localViewPoint
  }
}

//
//  DragGesture.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 1/8/2025.
//

import SwiftUI

extension DragGesture.Value {

  public var toRect: CGRect {
    CGRect.boundingRect(from: startLocation, to: location)
//    let origin = startLocation
//    let currentLocation = location
//    let newRect = CGRect.boundingRect(
//      from: origin,
//      to: currentLocation
//    )
//    return newRect
  }
}

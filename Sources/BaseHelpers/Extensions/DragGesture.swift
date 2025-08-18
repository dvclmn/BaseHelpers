//
//  DragGesture.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 1/8/2025.
//

import SwiftUI

extension DragGesture.Value {
  
  public var toRect: CGRect {
    let origin = startLocation
    let currentLocation = location
    let newRect = CGRect.boundingRect(
      from: origin,
      to: currentLocation
    )
    return newRect
  }
}

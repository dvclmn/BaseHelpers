//
//  Model+SmoothedProperty.swift
//  AnimationVisualiser
//
//  Created by Dave Coleman on 19/8/2025.
//

import Foundation

/// Was considering attaching this smoothed property concept
/// directly to a Wave property, like freq, amp, etc.
///
/// But have decided to keep it uncoupled.
public struct SmoothedProperty: ModelBase {
  public var target: CGFloat
  public var displayed: CGFloat

  public init(_ initial: CGFloat) {
    self.target = initial
    self.displayed = initial
  }

  public mutating func setTarget(_ newValue: CGFloat) {
    self.target = newValue
  }
  
  public mutating func snapUpdate(_ newValue: CGFloat) {
    self.update(dt: 0, smoothing: 0)
  }
  
  public mutating func update(
    dt: CGFloat,
    smoothing timeConstant: CGFloat
  ) {
    displayed = displayed.smoothed(
      towards: target,
      dt: dt,
      timeConstant: timeConstant
    )
  }
}


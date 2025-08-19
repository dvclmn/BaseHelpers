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
public struct SmoothedProperty: Documentable {
  public var target: CGFloat
  public var displayed: CGFloat

  public init(_ initial: CGFloat) {
    self.target = initial
    self.displayed = initial
  }

  public mutating func update(
    dt: CGFloat,
    timeConstant: CGFloat
  ) {
    displayed = displayed.smoothed(
      towards: target,
      dt: dt,
      timeConstant: timeConstant
    )
  }
}

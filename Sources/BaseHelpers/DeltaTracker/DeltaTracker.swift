//
//  DeltaTracker.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 24/6/2025.
//

import SwiftUICore

/// Tracks deltas between gesture values.
public struct DeltaTracker<Value: VectorArithmetic> {
  private var previous: Value?
  
  public init() {}
  
  public mutating func delta(from current: Value) -> Value {
    defer { previous = current }
    guard let previous else { return .zero }
    return current - previous
  }
  
  public mutating func reset() {
    previous = nil
  }
}

/// For scale-like values (zoom, rotation, etc)
public struct RatioTracker {
  let range: ClosedRange<Double>
  private var previous: CGFloat?
  
  public init(
    range: ClosedRange<Double> = 0.01...2.0
  ) {
    self.range = range
  }
  
  public mutating func ratio(from current: CGFloat) -> CGFloat {
    defer { previous = current }
    guard let previous, previous != 0 else { return 1 }
    
    let rawRatio = Double(current / previous)
    return CGFloat(rawRatio.clamped(to: range))
  }
  
//  public mutating func ratio(from current: CGFloat) -> CGFloat {
//    defer { previous = current }
//    guard let previous, previous != 0 else { return 1 } // neutral ratio
//    return current / previous
//  }
  
  public mutating func reset() {
    previous = nil
  }
}

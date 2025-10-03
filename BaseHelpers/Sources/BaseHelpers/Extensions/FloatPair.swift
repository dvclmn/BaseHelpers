//
//  FloatPair.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 10/7/2025.
//

import Foundation

/// I think `FloatPair` can be distinct from `ValuePair`

/// This is for helping unify some operations that benefit
/// both `CGPoint` and `CGSize`. This protocol does
/// care about axis; x/y, horizontal/vertical etc
public protocol FloatPair {
  /// For `CGPoint` this is `x`.
  /// For `CGSize` this is `width`
  var floatA: Double { get }

  /// For `CGPoint` this is `y`.
  /// For `CGSize` this is `height`
  var floatB: Double { get }
}

extension CGPoint: FloatPair {
  public var floatA: Double { x }
  public var floatB: Double { y }
}
extension CGSize: FloatPair {
  public var floatA: Double { width }
  public var floatB: Double { height }
}

public func - (lhs: any FloatPair, rhs: CGPoint) -> some FloatPair {
  return CGPoint(
    x: lhs.floatA - rhs.x,
    y: lhs.floatB - rhs.y
  )
}
public func / (lhs: any FloatPair, rhs: CGPoint) -> some FloatPair {
  return CGPoint(
    x: lhs.floatA / rhs.x,
    y: lhs.floatB / rhs.y
  )
}
public func / (lhs: any FloatPair, rhs: CGFloat) -> some FloatPair {
  return CGPoint(
    x: lhs.floatA / rhs,
    y: lhs.floatB / rhs
  )
}

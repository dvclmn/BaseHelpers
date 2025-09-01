//
//  Zeroable.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 2/9/2025.
//

import Foundation

/// Protocol for types that can be treated as "zero" when nil
public protocol Zeroable {
  static var zero: Self { get }
}

extension Double: Zeroable {
  public static var zero: Double { 0.0 }
}

extension UnitIntervalCyclic: Zeroable {
  public static var zero: UnitIntervalCyclic { 0.0 }
}

extension Optional where Wrapped: Zeroable {

  /// Applies an operation to two optionals, treating nil as zero
  public func combined<T>(
    with other: T?,
    using operation: (Wrapped, T) -> Wrapped
  ) -> Wrapped? where T: Zeroable {
    guard self != nil || other != nil else { return nil }
    
    let lhs = self ?? .zero
    let rhs = other ?? .zero
    return operation(lhs, rhs)
  }
//  public func combined<T>(
//    with other: T?,
//    using operation: (Wrapped, T) -> Wrapped
//  ) -> Wrapped? where T: Zeroable {
//    let fallBack = self.withDefault(.zero)
//    let otherWithDefault = other.withDefault(.zero)
//    let result = fallBack.combined(with: otherWithDefault, using: operation)
//    return result
//  }

  private func withDefault(_ defaultValue: Wrapped) -> Wrapped {
    return self ?? defaultValue
  }
}

extension Optional where Wrapped: Zeroable & BinaryFloatingPoint {

  /// Standard linear interpolation for floating point values
  public func interpolated(towards other: Wrapped?, strength: Wrapped) -> Wrapped? {
    guard self != nil || other != nil else { return nil }
    let from = self ?? .zero
    let to = other ?? .zero
    return lerp(from: from, to: to, strength)
  }
  
//  /// Standard linear interpolation for floating point values
//  public func interpolated(towards other: Wrapped?, strength: Wrapped) -> Wrapped? {
//    guard self != nil || other != nil else { return nil }
//    let from = self ?? .zero
//    let to = other ?? .zero
//    return lerp(from: from, to: to, strength)
//  }
}

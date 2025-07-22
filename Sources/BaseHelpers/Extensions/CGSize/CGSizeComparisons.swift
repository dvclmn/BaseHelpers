//
//  CGSizeComparisons.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 22/7/2025.
//

import Foundation

extension CGSize {

  enum DimensionMatchMode {
    case any
    case both

    func evaluate(lhs: Bool, rhs: Bool) -> Bool {
      switch self {
        case .any: return lhs || rhs
        case .both: return lhs && rhs
      }
    }
  }

  private func compareDimensions<T: BinaryFloatingPoint>(
    to value: T,
    using comparison: (CGFloat, CGFloat) -> Bool,
    matchMode: DimensionMatchMode
  ) -> Bool {
    let widthResult = comparison(width, CGFloat(value))
    let heightResult = comparison(height, CGFloat(value))

    switch matchMode {
      case .any:
        return widthResult || heightResult
      case .both:
        return widthResult && heightResult
    }
  }

  private func compareDimensions(
    to other: CGSize,
    using comparison: (CGFloat, CGFloat) -> Bool,
    matchMode: DimensionMatchMode
  ) -> Bool {
    let widthResult = comparison(width, other.width)
    let heightResult = comparison(height, other.height)

    switch matchMode {
      case .any:
        return widthResult || heightResult
      case .both:
        return widthResult && heightResult
    }
  }
}

extension CGSize {

  /// Returns true if both width and height are greater than zero
  public var isGreaterThanZero: Bool {
    width > 0 && height > 0
  }

  /// Returns true if both width and height are greater than or equal to zero
  public var isGreaterThanOrEqualToZero: Bool {
    width >= 0 && height >= 0
  }

  /// Returns true if either width or height is zero or negative
  public var isLessThanOrEqualToZero: Bool {
    !isGreaterThanZero
  }

  public func isAnyDimensionGreaterThan(_ value: CGFloat) -> Bool {
    compareDimensions(to: value, using: >, matchMode: .any)
  }

  public func areBothDimensionsGreaterThan(_ value: CGFloat) -> Bool {
    compareDimensions(to: value, using: >, matchMode: .both)
  }

  public func isAnyDimensionLessThan(_ value: CGFloat) -> Bool {
    compareDimensions(to: value, using: <, matchMode: .any)
  }

  public func areBothDimensionsLessThan(_ value: CGFloat) -> Bool {
    compareDimensions(to: value, using: <, matchMode: .both)
  }

  public func isAnyDimensionGreaterThan(_ other: CGSize) -> Bool {
    compareDimensions(to: other, using: >, matchMode: .any)
  }

  public func areBothDimensionsGreaterThan(_ other: CGSize) -> Bool {
    compareDimensions(to: other, using: >, matchMode: .both)
  }

  public func isAnyDimensionLessThan(_ other: CGSize) -> Bool {
    compareDimensions(to: other, using: <, matchMode: .any)
  }

  public func areBothDimensionsLessThan(_ other: CGSize) -> Bool {
    compareDimensions(to: other, using: <, matchMode: .both)
  }
}

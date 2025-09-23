//
//  BFP+Lerp.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 10/8/2025.
//

import Foundation

//
//  Lerp.swift
//
//  Written by Ramon Torres
//  Placed under public domain.
//

/// Code courtesy of https://rtorres.me/blog/lerp-swift/
/// Linearly interpolates between two values.
///
/// Interpolates between the values `v0` and `v1` by a factor `t`.
///
/// - Parameters:
///   - v0: The first value.
///   - v1: The second value.
///   - t: The interpolation factor. Between `0` and `1`.
/// - Returns: The interpolated value.
@inline(__always)
public func lerp<V: BinaryFloatingPoint, T: BinaryFloatingPoint>(from v0: V, to v1: V, _ t: T) -> V {
  return v0 + V(t) * (v1 - v0)
}

/// Linearly interpolates between two points.
///
/// Interpolates between the points `p0` and `p1` by a factor `t`.
///
/// - Parameters:
///   - p0: The first point.
///   - p1: The second point.
///   - t: The interpolation factor. Between `0` and `1`.
/// - Returns: The interpolated point.
@inline(__always)
public func lerp<T: BinaryFloatingPoint>(from p0: CGPoint, to p1: CGPoint, _ t: T) -> CGPoint {
  return CGPoint(
    x: lerp(from: p0.x, to: p1.x, t),
    y: lerp(from: p0.y, to: p1.y, t)
  )
}

/// Linearly interpolates between two sizes.
///
/// Interpolates between the sizes `s0` and `s1` by a factor `t`.
///
/// - Parameters:
///   - s0: The first size.
///   - s1: The second size.
///   - t: The interpolation factor. Between `0` and `1`.
/// - Returns: The interpolated size.
@inline(__always)
public func lerp<T: BinaryFloatingPoint>(from s0: CGSize, to s1: CGSize, _ t: T) -> CGSize {
  return CGSize(
    width: lerp(from: s0.width, to: s1.width, t),
    height: lerp(from: s0.height, to: s1.height, t)
  )
}

/// Linearly interpolates between two rectangles.
///
/// Interpolates between the rectangles `r0` and `r1` by a factor `t`.
///
/// - Parameters:
///   - r0: The first rectangle.
///   - r1: The second rectangle.
///   - t: The interpolation factor. Between `0` and `1`.
/// - Returns: The interpolated rectangle.
@inline(__always)
public func lerp<T: BinaryFloatingPoint>(from r0: CGRect, to r1: CGRect, _ t: T) -> CGRect {
  return CGRect(
    origin: lerp(from: r0.origin, to: r1.origin, t),
    size: lerp(from: r0.size, to: r1.size, t)
  )
}

/// Inverse linear interpolation.
///
/// Given a value `v` between `v0` and `v1`, returns the interpolation factor `t`
/// such that `v == lerp(v0, v1, t)`.
///
/// - Parameters:
///   - v0: The lower bound of the interpolation range.
///   - v1: The upper bound of the interpolation range.
///   - v: The value to interpolate.
/// - Returns: The interpolation factor `t` such that `v == lerp(v0, v1, t)`.
@inline(__always)
public func inverseLerp<V: BinaryFloatingPoint, T: BinaryFloatingPoint>(_ v0: V, _ v1: V, _ v: V) -> T {
  return T((v - v0) / (v1 - v0))
}

// swiftlint:enable identifier_name

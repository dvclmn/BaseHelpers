//
//  MappingCurve.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 24/8/2025.
//

import Foundation
import CurveFunctions

extension BinaryFloatingPoint {

  /// Maps `self`  into a derived value (e.g. corner radius or padding),
  /// favouring non-linear mapping via a curve.
  ///
  /// - Parameters:
  ///   - inputRange: The expected bounds of the input.
  ///   - outputRange: The target range for the derived value.
  ///   - curve: A non-linear adjustment function, like `.squareRoot()`, or a custom easing.
  ///   - clamped: Whether to clamp input to the input range.
  /// - Returns: A derived value smoothly mapped from size.
  ///
  /// E.g.:
  /// ```
  /// let scaled = value.mappedNonLinearly(
  ///   from: 0...100,
  ///   to: 10...50,
  ///   curve: .exponential,
  ///   ease: .inOut
  /// )
  /// ```
  ///
  /// Input range = the domain: “What numbers are we feeding into the curve?”
  /// Output range = the codomain: “What numbers do we want back out?”
  ///
  /// Example 1: mapping scroll position to opacity
  /// ```
  /// inputRange  = 100...300   // scroll distance in points
  /// outputRange = 0...1       // opacity
  /// curve       = exponential
  /// ease        = inOut
  /// ```
  ///
  /// Example 2: mapping time to y-position
  /// ```
  /// inputRange  = 0…2       // seconds
  /// outputRange = 200…800   // pixel position
  /// curve       = sine
  /// ease        = none
  /// ```
  ///
  /// For playing with a `strength` factor:
  /// ```
  /// let curved = ease.apply(
  ///   using: curve,
  ///   to: Double(normalised)
  /// ) * strength
  /// ```
  public func mappedNonLinearly(
    from inputRange: ClosedRange<Self> = 0...1,
    to outputRange: ClosedRange<Self>,
    curve: CurveFunction = .quartic,
    ease: EaseDirection = .in,
    //    curve: CurveType = .shaped(.logar, .inOut),
    //    curve: CurveFunction = .linear,
    //    ease: Ease = .none,
    clampedToInputRange clamped: Bool = true
  ) -> Self {
    
    /// `clamped` controls whether overshoot is allowed or not.
    ///
    /// Clamped: if value is below `inputRange.lowerBound`,
    /// it gets set to `.lowerBound` (and same for `.upperBound`).
    /// Unclamped: the curve still applies, but normalised `x` can go
    /// below` 0` or above `1`, meaning:
    /// -  Exponential/log curves may go negative or overshoot above 1
    /// -  Ease functions may produce unexpected swings
    ///
    /// Clamped is good for animations that should stay strictly
    /// within a range (e.g. slider positions, alpha values).
    /// Unclamped is useful for effects like elastic overshoot or values
    /// that need to continue beyond the target.
    let clampedSelf = clamped ? self.clamped(to: inputRange) : self
    
    /// A “shift and scale” step to normalise a value.
    /// Subtracting the `lowerBound` shifts the input so the start of the range is at `0`
    /// Dividing by the range width (span) scales it so the end of the range is at `1`
    /// This normalisation step means the curve function always
    /// works in a predictable `0…1` space
    ///
    // | Input range | Value | Shifted | Normalised |
    // |-------------|-------|---------|------------|
    // | 10…20       | 15    | 5       | 0.5        |
    // | 10…20       | 18    | 8       | 0.8        |
    
    let inputSpan = inputRange.upperBound - inputRange.lowerBound
    let normalised = (clampedSelf - inputRange.lowerBound) / inputSpan
    
    let function = EasingFunction(curve, ease)
    let curved = function.value(for: Double(normalised))
    //    let curved = ease.apply(using: curve, to: Double(normalised))
    let outputSpan = outputRange.upperBound - outputRange.lowerBound
    return outputRange.lowerBound + Self(curved) * outputSpan
  }
}

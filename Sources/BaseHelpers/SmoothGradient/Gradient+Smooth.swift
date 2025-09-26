//
//  Gradient+Smooth.swift
//  SmoothGradient
//
//  Copyright (c) 2023-2024 Ramon Torres
//
//  This file is part of SmoothGradient which is released under the MIT license.
//  See the LICENSE file in the root directory of this source tree for full details.
//

import SwiftUI

// MARK: - iOS 17

#if compiler(>=5.9)
extension Gradient {
  /// Creates a gradient with the given easing function.
  ///
  /// - Parameters:
  ///   - from: The start color.
  ///   - to: The end color.
  ///   - curve: The easing function to use.
  ///   - steps: The number of steps to use when generating the gradient. Defaults to 16.
  /// - Returns: A gradient.
  @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
  public static func smooth(
    from: Color,
    to: Color,
    curve: UnitCurve = .easeInOut,
    steps: Int = 16
  ) -> Gradient {
    return makeSmoothStepGradient(
      from: Stop(color: from, location: 0),
      to: Stop(color: to, location: 1),
      curve: curve,
      steps: steps
    )
  }

  /// Creates a gradient with the given easing function.
  ///
  /// - Parameters:
  ///   - from: The start color.
  ///   - to: The end color.
  ///   - curve: The easing function to use.
  ///   - steps: The number of steps to use when generating the gradient. Defaults to 16.
  /// - Returns: A gradient.
  @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
  public static func smooth(
    from: Stop,
    to: Stop,
    curve: UnitCurve = .easeInOut,
    steps: Int = 16
  ) -> Gradient {
    return makeSmoothStepGradient(
      from: from,
      to: to,
      curve: curve,
      steps: steps
    )
  }
}
#endif

// MARK: - Factory

extension Gradient {
  private static func makeSmoothStepGradient(
    from: Stop,
    to: Stop,
    curve: UnitCurve,
    steps: Int
  ) -> Gradient {
    let ramp = stride(from: 0, to: steps, by: 1).lazy.map { index in
      Double(index) / Double(steps - 1)
    }

    let interpolator = GradientInterpolator(
      curve: curve,
      color1: from.color,
      color2: to.color
    )

    return Gradient(
      stops: ramp.map { progress in
        Stop(
          color: interpolator.blend(progress: progress),
          location: from.location + progress * (to.location - from.location)
        )
      })
  }
}

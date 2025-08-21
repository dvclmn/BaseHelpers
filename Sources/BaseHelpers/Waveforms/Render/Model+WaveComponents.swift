//
//  Model+WaveComponents.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 21/8/2025.
//

import Foundation

public struct WaveComponents: OptionSet, Sendable {
  public init(rawValue: Int) {
    self.rawValue = rawValue
  }
  public let rawValue: Int

  public static let line = Self(rawValue: 1 << 0)
  public static let points = Self(rawValue: 1 << 1)
  public static let labels = Self(rawValue: 1 << 2)
  public static let phaseGhost = Self(rawValue: 1 << 2)
  public static let all: Self = [.line, .points, .labels, phaseGhost]
}

public enum WaveViewStyle: Equatable {
  case standard
  case preview(maxHeight: CGFloat = 50)
}

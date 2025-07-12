//
//  Model+DebugElements.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 12/7/2025.
//

public struct PathDebugElements: OptionSet, Sendable {
  public init(rawValue: Int) {
    self.rawValue = rawValue
  }
  public let rawValue: Int

  public static let nodes = Self(rawValue: 1 << 0)
  public static let controlPoints = Self(rawValue: 1 << 1)
  public static let stroke = Self(rawValue: 1 << 2)
  public static let fill = Self(rawValue: 1 << 3)
  public static let labels = Self(rawValue: 1 << 4)
  public static let all: Self = [.nodes, .controlPoints, .stroke, .fill, .labels]
}

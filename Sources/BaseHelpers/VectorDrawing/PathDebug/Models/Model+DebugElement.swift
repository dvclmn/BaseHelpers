//
//  Model+PathPoint.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 12/7/2025.
//

import SwiftUI

public enum DebugPathElement: Hashable, CaseIterable {
  case nodeMove
  case nodeLine
  case controlBezier
  case controlQuad
  case connection
  case close

  public init(fromElement element: Path.Element) {
    self =
      switch element {
        case .move: .nodeMove
        case .line: .nodeLine
        case .quadCurve: .controlQuad
        case .curve: .controlBezier
        case .closeSubpath: .close
      }
  }

  public var shape: PointShape {
    switch self {
      case .nodeMove: .triangle
      case .nodeLine: .square
      case .controlBezier, .controlQuad: .circle
      case .connection, .close: .cross
    }
  }
  
  var isLabelled: Bool {
    switch self {
      case .nodeMove, .nodeLine: true
//      case .nodeMove, .nodeLine, .controlBezier, .controlQuad: true
      default: false
    }
  }

  public var displayColour: Color {
    switch self {
      case .nodeMove: .cyan
      case .nodeLine: .blue
      case .controlBezier: .orange
      case .controlQuad: .orange
      case .connection: .brown
      case .close: .pink
    }
  }

}

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

public enum PointSize: CGFloat {
  case mini = 2
  case small = 4
  case normal = 6
  case large = 10
  case huge = 14
}

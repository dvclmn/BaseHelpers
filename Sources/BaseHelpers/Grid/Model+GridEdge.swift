//
//  Model+GridEdge.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 29/7/2025.
//

import SwiftUI

public enum GridEdge: String, GridBase, CaseIterable {
  case top
  case trailing
  case bottom
  case leading

  public var name: String { rawValue.capitalized }

  public init?(fromBoundaryPoint point: GridBoundaryPoint) {
    guard let edge = point.gridEdge else { return nil }
    self = edge
  }

  public var gridBoundaryPoint: GridBoundaryPoint {
    let point = GridBoundaryPoint(fromEdge: self)
    return point
  }

  public var gridAxis: GridAxis {
    switch self {
      case .top, .bottom: return .row
      case .leading, .trailing: return .column
    }
  }

}

extension GridEdge {
  public struct Set: OptionSet, Sendable {
    public init(rawValue: Int) {
      self.rawValue = rawValue
    }
    public let rawValue: Int

    public static let top = Self(rawValue: 1 << 0)
    public static let trailing = Self(rawValue: 1 << 1)
    public static let bottom = Self(rawValue: 1 << 2)
    public static let leading = Self(rawValue: 1 << 3)
    public static let all: Self = [.top, .trailing, .bottom, .leading]
  }
}

extension GridEdge.Set {
  public init(_ edge: GridEdge) {
    switch edge {
      case .top: self = .top
      case .trailing: self = .trailing
      case .bottom: self = .bottom
      case .leading: self = .leading
    }
  }

  public var names: String {
    GridEdge.allCases
      .filter { contains(Self($0)) }
      .map(\.name)
      .joined(separator: ", ")
  }
}

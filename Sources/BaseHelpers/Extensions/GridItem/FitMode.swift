//
//  GridMode.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 2/10/2025.
//

import SwiftUI

extension GridConfig {

  public enum FitMode: RawRepresentable, ModelBase {
    case fill(min: CGFloat, max: CGFloat = .infinity)
    case fixedWidth(width: CGFloat)

    public init?(rawValue: String) {
      switch rawValue {
        case "Fill": self = .fill(min: 100)
        case "Fixed": self = .fixedWidth(width: 0)
        default: return nil
      }
    }

    public var rawValue: String {
      switch self {
        case .fill: "fill"
        case .fixedWidth: "fixed"
      }
    }

    public var name: String { rawValue.capitalized }

    public var minAndMax: (min: CGFloat, max: CGFloat) {
      switch self {
        case .fill(let min, let max):
          return (min, max)
        case .fixedWidth(let width):
          return (width, width)
      }
    }
  }
}

extension GridConfig.FitMode: CustomStringConvertible {

  public var description: String {
    return StringGroup {
      "FitMode"
      switch self {
        case .fill(let min, let max): "Fill [min: \(min), max: \(max)]"
        case .fixedWidth(let width): "Fixed Width [width: \(width)]"
      }
    }.output
  }
}

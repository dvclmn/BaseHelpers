//
//  Model+WavePoints.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 19/8/2025.
//

import SwiftUI

struct PointStyle: Documentable {
  var size: CGFloat = 4
  var shape: Shape = .circle
  var colour: Swatch = .green50

  public init(
    size: CGFloat,
    shape: Shape,
    colour: Swatch,
  ) {
    self.size = size
    self.shape = shape
    self.colour = colour
  }

  /// I don't think visual style should be concerned with
  /// something that relates to performance
  //  var count: Double = 100

  static let sizeRange: ClosedRange<Double> = 1...120
  static let swatches: [Swatch] = [.yellow30, .purple20, .brown40]

  enum Shape: Documentable, CaseIterable {
    case none
    case circle
    case square
    case diamond

    var value: AnyShape? {
      switch self {
        case .none: nil
        case .circle: AnyShape(.circle)
        case .square: AnyShape(.rect)
        case .diamond: AnyShape(Diamond())
      }
    }

    var name: String {
      switch self {
        case .none: "None"
        case .circle: "Circle"
        case .square: "Square"
        case .diamond: "Diamond"
      }
    }

    var icon: String {
      switch self {
        case .none: "circle.slash"
        case .circle: "circle.fill"
        case .square: "square.fill"
        case .diamond: "diamond.fill"
      }
    }
  }
}

//struct CyclesAcross: Documentable {
//  var count: CGFloat = 4
  
//}

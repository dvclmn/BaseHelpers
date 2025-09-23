//
//  Model+WavePoints.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 19/8/2025.
//

import SwiftUI

public struct PointStyle: ModelBase {
  let diameter: CGFloat
  let shape: Shape
  let colour: Swatch

  public init(
    diameter: CGFloat = 4,
    shape: Shape = .circle,
    colour: Swatch = .green50,
  ) {
    self.diameter = diameter
    self.shape = shape
    self.colour = colour
  }

  /// I don't think visual style should be concerned with
  /// something that relates to performance
  //  var count: Double = 100

  public static let sizeRange: ClosedRange<Double> = 1...120
  public static let swatches: [Swatch] = [.yellow30, .purple20, .brown40]

  public enum Shape: ModelBase, CaseIterable {
    case none
    case circle
    case square
    case diamond

    public var value: AnyShape? {
      switch self {
        case .none: nil
        case .circle: AnyShape(.circle)
        case .square: AnyShape(.rect)
        case .diamond: AnyShape(Diamond())
      }
    }

    public var name: String {
      switch self {
        case .none: "None"
        case .circle: "Circle"
        case .square: "Square"
        case .diamond: "Diamond"
      }
    }

    public var icon: String {
      switch self {
        case .none: "circle.slash"
        case .circle: "circle.fill"
        case .square: "square.fill"
        case .diamond: "diamond.fill"
      }
    }
  }
}

//struct CyclesAcross: Model {
//  var count: CGFloat = 4
  
//}

//
//  Model+PathPoint.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 12/7/2025.
//

import SwiftUI

public protocol PointType {
  var shape: PointShape { get }
  var colour: Color { get }
}

public struct Node: PointType {
  public let shape: PointShape
  public let colour: Color
  
  public init(
    shape: PointShape = .square,
    colour: Color = .brown
  ) {
    self.shape = shape
    self.colour = colour
  }
}

public struct ControlPoint: PointType {
  public let shape: PointShape
  public let colour: Color
  
  public init(
    shape: PointShape = .circle,
    colour: Color = .green,
  ) {
    self.shape = shape
    self.colour = colour
  }
}

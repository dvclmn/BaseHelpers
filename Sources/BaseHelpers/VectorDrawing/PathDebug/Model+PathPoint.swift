//
//  Model+PathPoint.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 12/7/2025.
//

import SwiftUI

public enum PointType {
  case node
  case control
}
public protocol PathPoint {
  var type: PointType { get }
  var style: PointStyle { get }
  //  var shape: PointShape { get }
  //  var size: PointSize { get }
  //  var colour: Color { get }
}

public struct PointStyle {
  //  public let type: PointType
  public let colour: Color
  public let shape: PointShape
  public let size: PointSize

  public init(
    //    type: PointType,
    colour: Color = .brown,
    shape: PointShape = .square,
    size: PointSize = .normal,
  ) {
    //    self.type = type
    self.colour = colour
    self.shape = shape
    self.size = size
  }
}

public struct ControlPoint: PathPoint {
  public var type: PointType { .control }
  public let style: PointStyle

  public init(
    style: PointStyle = .init()
  ) {
    self.style = style
  }

}
public struct Node: PathPoint {
  public var type: PointType { .node }
  public let style: PointStyle
  
  public init(
    style: PointStyle = .init()
  ) {
    self.style = style
  }
  
}

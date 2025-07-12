//
//  Model+PathPoint.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 12/7/2025.
//

import SwiftUI

//public enum PointType {
//  case node
//  case control
//  
//  public var shape: PointShape {
//    switch self {
//      case .node: .square
//      case .control: .circle
//    }
//  }
//}
//public protocol PathPoint {
//  var type: PointType { get }
//  var style: PointStyle { get }
//}

public struct PointStyle {
  public let displayName: String
  public let shape: PointShape
  public let colour: Color
  public let size: PointSize

//  public init(
//    colour: Color = .brown,
//    size: PointSize = .normal,
//  ) {
//    self.colour = colour
//    self.size = size
//  }
}

//public struct ControlPoint: PathPoint {
//  public var type: PointType { .control }
//  public let style: PointStyle
//
//  public init(
//    style: PointStyle = .init()
//  ) {
//    self.style = style
//  }
//
//}
//public struct Node: PathPoint {
//  public var type: PointType { .node }
//  public let style: PointStyle
//  
//  public init(
//    style: PointStyle = .init()
//  ) {
//    self.style = style
//  }
//  
//}

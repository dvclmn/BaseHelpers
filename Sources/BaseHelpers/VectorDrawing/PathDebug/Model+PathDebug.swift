//
//  Models.swift
//  Components
//
//  Created by Dave Coleman on 30/9/2024.
//

import SwiftUI

public struct PathDebug<T: Shape> {
  public let shape: T
  
  
  public func debugPaths(in rect: CGRect) -> DebugPaths {
    let originalPath = shape.path(in: rect)
    let paths: DebugPaths = PathAnalyser.analyse(originalPath, config: config)
    return paths
  }
}

public typealias ColouredPoint = (point: CGPoint, color: Color)

public struct DebugPaths {
  public let original: Path
  public let nodes: Path
  public let controlPoints: Path
  public let connections: Path

}

//public struct StrokeConfig {
//  var colour: Color
//  var width: CGFloat
//  
//  public init(
//    colour: Color = .gray,
//    width: CGFloat = 1,
//  ) {
//    self.colour = colour
//    self.width = width
//  }
//}




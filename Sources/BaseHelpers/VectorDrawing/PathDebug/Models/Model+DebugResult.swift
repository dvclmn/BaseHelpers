//
//  Model+DebugResult.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 12/7/2025.
//

import SwiftUI

public struct PathDebugResult {
  public let original: Path
  public let debugPaths: DebugPaths
  
  public var connections: Path { debugPaths[.connection] ?? Path() }
  
  public var nodes: Path {
    var combined = Path()
    if let moves = debugPaths[.nodeMove] { combined.addPath(moves) }
    if let lines = debugPaths[.nodeLine] { combined.addPath(lines) }
    return combined
  }
  public var controlPoints: Path {
    var combined = Path()
    if let bezier = debugPaths[.controlBezier] { combined.addPath(bezier) }
    if let quad = debugPaths[.controlQuad] { combined.addPath(quad) }
    return combined
  }
}

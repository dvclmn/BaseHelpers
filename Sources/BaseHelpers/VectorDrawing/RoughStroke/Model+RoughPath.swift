//
//  Modifiers.swift
//  Components
//
//  Created by Dave Coleman on 11/12/2024.
//

import SwiftUI

public struct RoughPath<S: Shape>: Shape {  
  let sourceShape: S
  let style: RoughPathStyle
  
  public init(
    _ source: S,
    style: RoughPathStyle
  ) {
    self.sourceShape = source
    self.style = style
  }
  
  public func path(in rect: CGRect) -> Path {
    let path = sourceShape.path(in: rect)
    
    var generator = RoughPathGenerator(style: style)
    var roughPath = generator.roughenPath(path)
    
    roughPath.closeSubpath()
    return roughPath
  }
}

public extension Shape {
  func roughen(
    roughness: CGFloat = 10,
    segments: CGFloat = 20,
    jitter: CGFloat = 4
  ) -> some Shape {
    return RoughPath(
      self,
      style: RoughPathStyle(
        roughness: roughness,
        segments: Int(segments),
        seed: 312,
        jitter: jitter
      )
    )
  }
}

//extension GraphicsContext {
//  public mutating func roughStroke(
//    _ path: Path,
//    style: RoughStrokeStyle,
//    color: Color = .black,
//    lineWidth: CGFloat = 1
//  ) {
//    var generator = RoughPathGenerator(style: style)
//    let roughPath = generator.roughenPath(path)
//    stroke(roughPath, with: .color(color), lineWidth: lineWidth)
//  }
//}

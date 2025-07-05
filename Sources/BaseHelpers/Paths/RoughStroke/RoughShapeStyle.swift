//
//  RoughShapeStyle.swift
//  Components
//
//  Created by Dave Coleman on 11/12/2024.
//

import SwiftUI

//public struct RoughShapeStyle {
//  let roughness: CGFloat
//  let segments: Int
//  let seed: UInt64
//  
//  public init(
//    roughness: CGFloat = 10,
//    segments: Int = 20,
//    seed: UInt64 = 0
//  ) {
//    self.roughness = roughness
//    self.segments = segments
//    self.seed = seed
//  }
//}





//public struct RoughStrokeShapeStyle: ShapeStyle {
//  let baseStyle: RoughStrokeStyle
//  let baseColor: Color
//  let lineWidth: CGFloat
//  
//  public init(
//    style: RoughStrokeStyle = .default,
//    color: Color = .black,
//    lineWidth: CGFloat = 1
//  ) {
//    self.baseStyle = style
//    self.baseColor = color
//    self.lineWidth = lineWidth
//  }
//  
//  public func resolve(in environment: EnvironmentValues) -> some ShapeStyle {
//    // Return a concrete ShapeStyle based on the environment
//    baseColor.opacity(environment.colorScheme == .dark ? 0.8 : 1.0)
//  }
//}

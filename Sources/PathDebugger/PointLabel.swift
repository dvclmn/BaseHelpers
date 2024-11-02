//
//  PointLabel.swift
//  Components
//
//  Created by Dave Coleman on 30/9/2024.
//

import SwiftUI


public extension CGPoint {
  struct Label: Equatable, Hashable {
    let text: String
    let color: Color
  }
  
  func withLabel(_ text: String, color: Color = .black) -> LabeledPoint {
    LabeledPoint(point: self, label: Label(text: text, color: color))
  }
}

public struct LabeledPoint: Equatable, Hashable {
  let point: CGPoint
  let label: CGPoint.Label
  
  func offsetBy(dx: CGFloat, dy: CGFloat) -> LabeledPoint {
    LabeledPoint(point: CGPoint(x: point.x + dx, y: point.y + dy), label: label)
  }
}

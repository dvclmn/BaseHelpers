//
//  Pattern+Stitches.swift
//  BaseComponents
//
//  Created by Dave Coleman on 12/5/2025.
//

import SwiftUI

extension GraphicsContext {
  public func drawStitches(
    config: PatternConfiguration,
    size: CGSize
  ) {
    let stitchesHeight = config.size * 2
    let repetitions = Int(ceil(size.height / stitchesHeight)) + 1

    for row in -1..<repetitions {
      var path = Path()
      let startY = CGFloat(row) * stitchesHeight

      for x in stride(from: -config.size, through: size.width + config.size, by: config.size) {
        path.move(to: CGPoint(x: x, y: startY))
        path.addLine(to: CGPoint(x: x + config.size, y: startY + stitchesHeight / 2))
        path.addLine(to: CGPoint(x: x + config.size * 2, y: startY))
      }

      self.stroke(path, with: .color(config.primaryColour.swiftUIColour), lineWidth: config.gap)

      path = Path()
      for x in stride(from: -config.size, through: size.width + config.size, by: config.size) {
        path.move(to: CGPoint(x: x, y: startY + stitchesHeight))
        path.addLine(to: CGPoint(x: x + config.size, y: startY + stitchesHeight / 2))
        path.addLine(to: CGPoint(x: x + config.size * 2, y: startY + stitchesHeight))
      }

      self.stroke(path, with: .color(config.secondaryColour.swiftUIColour), lineWidth: config.gap)
    }
  }

}

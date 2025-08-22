//
//  Pattern+Waves.swift
//  BaseComponents
//
//  Created by Dave Coleman on 12/5/2025.
//

import SwiftUI

extension GraphicsContext {

  public func drawWaves(
    config: PatternConfiguration,
    size: CGSize
  ) {
    let waveHeight = config.size
    let repetitions = Int(ceil(size.height / waveHeight)) + 1

    for row in -1..<repetitions {
      var path = Path()
      let startY = CGFloat(row) * waveHeight

      path.move(to: CGPoint(x: -config.size, y: startY))

      for x in stride(from: -config.size, through: size.width + config.size, by: config.size) {
        path.addQuadCurve(
          to: CGPoint(x: x + config.size, y: startY),
          control: CGPoint(x: x + config.size / 2, y: startY + waveHeight / 2)
        )
      }

      self.stroke(path, with: .color(config.primaryColour.swiftUIColor), lineWidth: config.gap)

      /// Second wave, offset
      path = Path()
      path.move(to: CGPoint(x: -config.size, y: startY + waveHeight / 2))

      for x in stride(from: -config.size, through: size.width + config.size, by: config.size) {
        path.addQuadCurve(
          to: CGPoint(x: x + config.size, y: startY + waveHeight / 2),
          control: CGPoint(x: x + config.size / 2, y: startY)
        )
      }

      self.stroke(path, with: .color(config.secondaryColour.swiftUIColor), lineWidth: config.gap)
    }
  }
}

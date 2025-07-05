//
//  Pattern+Checkerboard.swift
//  BaseComponents
//
//  Created by Dave Coleman on 12/5/2025.
//

import SwiftUI

extension GraphicsContext {

  public func drawStripes(
    config: PatternConfiguration,
    size: CGSize
  ) {
    let stripeWidth = config.size + config.gap
    let repetitions = Int(ceil(size.width / stripeWidth)) + 1
    
    for i in 0..<repetitions {
      let x = CGFloat(i) * stripeWidth
      let rect = CGRect(x: x, y: 0, width: config.size, height: size.height)
      let color = i.isMultiple(of: 2) ? config.primaryColour.nativeColour : config.secondaryColour.nativeColour
      self.fill(Path(rect), with: .color(color))
    }
  }
}

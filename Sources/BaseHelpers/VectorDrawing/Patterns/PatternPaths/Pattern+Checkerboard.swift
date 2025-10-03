//
//  Pattern+Checkerboard.swift
//  BaseComponents
//
//  Created by Dave Coleman on 12/5/2025.
//

import SwiftUI

extension GraphicsContext {
  
  func drawCheckerboard(
    config: PatternConfiguration,
    size: CGSize,
  ) {
    let rows = Int(ceil(size.height / config.size)) + 1
    let cols = Int(ceil(size.width / config.size)) + 1
    
    for row in 0..<rows {
      for col in 0..<cols {
        let x = CGFloat(col) * config.size + config.offset.width.truncatingRemainder(dividingBy: config.size)
        let y = CGFloat(row) * config.size + config.offset.height.truncatingRemainder(dividingBy: config.size)
        
        let rect = CGRect(x: x, y: y, width: config.size, height: config.size)
        let color = (row + col).isMultiple(of: 2) ? config.primaryColour.swiftUIColour : config.secondaryColour.swiftUIColour
        self.fill(Path(rect), with: .color(color))
      }
    }
  }
}

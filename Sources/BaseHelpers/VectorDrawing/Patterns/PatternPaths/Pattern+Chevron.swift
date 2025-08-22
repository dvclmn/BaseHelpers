//
//  Pattern+Checkerboard.swift
//  BaseComponents
//
//  Created by Dave Coleman on 12/5/2025.
//

import SwiftUI

extension GraphicsContext {

  public func drawChevron(
    config: PatternConfiguration,
    size: CGSize
  ) {
    /// The vertical distance between peaks and valleys of a single zig-zag
    let zigZagHeight = config.size * 2
    
    let lineWidth = config.size * 0.8
    
    /// Calculates how many complete zig-zag rows we need to fill the canvas height
    /// We add 1 to ensure we cover the bottom edge of the canvas
    /// Each "row" represents one complete zig-zag pattern
    let repetitions = Int(ceil(size.height / (zigZagHeight + config.gap))) + 3
    
    /// Iterate through each row of zig-zags
    /// The `-2` start ensures we cover the top edge of the canvas
    for row in -2..<repetitions {
      var path = Path()
      
      /// Calculate the starting Y position for this row
      /// - zigZagHeight: Controls the height of one zig-zag
      /// - config.gap: Controls the vertical spacing between zig-zag rows
      /// - row: Which row we're currently drawing
      let startY = CGFloat(row) * (zigZagHeight + (lineWidth + (config.gap * 1)))
      
      /// Start the path slightly off-screen to ensure pattern fills completely
      path.move(to: CGPoint(x: -config.size, y: startY))
      
      /// Controls whether the next point should be lower (peak) or higher (valley)
      var isGoingDown = true
      
      /// Create the zig-zag by adding points across the width of the canvas
      /// Each iteration adds one line segment of the zig-zag
      for x in stride(
        from: -config.size,
        through: size.width + (config.size * 2),
        by: config.size
      ) {
        /// Calculate the Y position for the next point
        /// When going down, add zigZagHeight to create a peak
        /// When going up, return to the baseline (startY) to create a valley
        let nextY = isGoingDown ? startY + zigZagHeight : startY
        path.addLine(to: CGPoint(x: x, y: nextY))
        isGoingDown.toggle()
      }
      
      /// Draw the path with the specified line width
      self.stroke(path, with: .color(config.primaryColour.swiftUIColor), lineWidth: lineWidth)
    }
  }
}

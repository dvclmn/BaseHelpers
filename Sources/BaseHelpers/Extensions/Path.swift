//
//  Path.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 6/7/2025.
//

import SwiftUI

extension Path {
  public static func createGrid(
    cellSize: CGSize,
    containerSize: CGSize,
    columns: Int,
    rows: Int
  ) -> Path {
    Path { p in
      /// Horizontal lines
      for row in 0...rows {
        let y = CGFloat(row) * cellSize.height
        p.move(to: CGPoint(x: 0, y: y))
        p.addLine(to: CGPoint(x: containerSize.width, y: y))
      }
      
      /// Vertical lines
      for column in 0...columns {
        let x = CGFloat(column) * cellSize.width
        p.move(to: CGPoint(x: x, y: 0))
        p.addLine(to: CGPoint(x: x, y: containerSize.height))
      }
    }
  }

//  private func drawLinesForGrid(
//    path p: inout Path,
//    axis: Axis,
//    count: Int,
//    cellSize: CGSize,
//    containerSize: CGSize
//  ) {
//    let cellLength = axis.length(size: cellSize)
//    let containerLength = axis.length(size: containerSize)
//    
//    for segment in 0...count {
//      let dimension = CGFloat(segment) * cellLength
//      p.move(to: CGPoint(x: x, y: 0))
//      p.addLine(to: CGPoint(x: x, y: containerSize.height))
//    }
//  }
}

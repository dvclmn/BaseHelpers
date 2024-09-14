//
//  CellGrid.swift
//  DrawString
//
//  Created by Dave Coleman on 28/8/2024.
//

import SwiftUI

public struct CellGridModifier: ViewModifier {
  
  var grid: GlyphGrid
  
  /// This allows the grid to fill the available area
  var autoSize: Bool
  var opacity: Double
  
  public func body(content: Content) -> some View {
    content
      .overlay {

        Canvas { context, size in
          
          let cellWidth = grid.cell.size.width
          let cellHeight = grid.cell.size.height
          
          
          var rowCount: Int
          var columnCount: Int
          
          if autoSize {
            rowCount = size.cellsThatFit(grid.cell.size).rows
            columnCount = size.cellsThatFit(grid.cell.size).columns
          } else {
            rowCount = grid.dimensions.rows
            columnCount = grid.dimensions.columns
          }
          
          let rows: Range = 1..<rowCount
          let columns: Range = 1..<columnCount
          
          // Draw vertical lines
          for column in columns {
            let x = CGFloat(column) * cellWidth
            let start = CGPoint(x: x, y: 0)
            let end = CGPoint(x: x, y: size.height)
            let path = Path { p in
              p.move(to: start)
              p.addLine(to: end)
            }
            context.stroke(path, with: .color(.secondary.opacity(opacity)), lineWidth: 0.2)
          }
          
          // Draw horizontal lines
          for row in rows {
            let y = CGFloat(row) * cellHeight
            let start = CGPoint(x: 0, y: y)
            let end = CGPoint(x: size.width, y: y)
            let path = Path { p in
              p.move(to: start)
              p.addLine(to: end)
            }
            context.stroke(path, with: .color(.secondary.opacity(opacity)), lineWidth: 0.2)
          }
          
        } // END canvas
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .allowsHitTesting(false)
      }
  }
}

extension CellGridModifier {

  
  
}


public extension View {
  func cellGrid(
    grid: GlyphGrid,
    autoSize: Bool = true,
    opacity: Double = 0.3
  ) -> some View {
    self.modifier(
      CellGridModifier(
        grid: grid,
        autoSize: autoSize,
        opacity: opacity
      )
    )
  }
}


struct CellGridExample: View {
  
  let grid = GlyphGrid(
    cell: .init(fontName: .sfMono),
    dimensions: GridDimensions(rows: 20, columns: 30),
    type: .canvas(GlyphGrid.Artwork.default)
  )
  
  var body: some View {
    
    VStack {
      Text("Hello")
        .padding(40)
        .frame(width: 320.0.snapToCell(cellSize: grid.cell.size), height: 700)
        .cellGrid(grid: grid)
        .background(.teal.opacity(0.05))
    }
    .frame(width: 600, height: 700)
    .background(.black.opacity(0.6))
    
  }
}
#Preview {
  CellGridExample()
}



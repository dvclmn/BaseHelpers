//
//  Grid+Dimensions.swift
//  Collection
//
//  Created by Dave Coleman on 8/12/2024.
//

import Foundation

public struct GridDimensions: Equatable, Sendable {
  
  private let rows: Int
  private let columns: Int
  
  public init(
    rows: Int = 8,
    columns: Int = 5
  ) {
    assert(rows >= 1 && columns >= 1, "Cannot initialise grid with values of zero or less.")
    self.rows = max(1, rows)
    self.columns = max(1, columns)
  }
  
  public static let example: GridDimensions = GridDimensions(rows: 20, columns: 10)
}

public enum GridEdge {
  case leading  // Left for width, Top for height
  case trailing // Right for width, Bottom for height
}

public enum GridDimension {
  case width
  case height
  
  public var nameInitial: String {
    switch self {
      case .width: "W"
      case .height: "H"
    }
  }
  
  public var name: String {
    switch self {
      case .width: "Width"
      case .height: "Height"
    }
  }
}

public struct GridDimensionChange {
  let dimension: GridDimension
  let edge: GridEdge
  let delta: Int // Positive for addition, negative for removal
  
  public init(
    dimension: GridDimension,
    edge: GridEdge,
    delta: Int
  ) {
    self.dimension = dimension
    self.edge = edge
    self.delta = delta
  }
}


public extension GlyphGrid {
  mutating func changeDimension(_ change: GridDimensionChange) {
    switch change.dimension {
      case .width:
        adjustWidth(edge: change.edge, delta: change.delta)
      case .height:
        adjustHeight(edge: change.edge, delta: change.delta)
    }
  }
  
  private mutating func adjustWidth(edge: GridEdge, delta: Int) {
    let oldWidth = width
    let oldHeight = height
    let newWidth = width + delta
    
    // Create new cells array
    var newCells: [Cell] = []
    
    for row in 0..<oldHeight {
      let oldRowStart = row * oldWidth
//      let newRowStart = row * newWidth
      
      switch edge {
        case .leading:
          // Add empty cells at start of row
          if delta > 0 {
            // Add new empty cells
            for _ in 0..<delta {
              newCells.append(Cell())
            }
          }
          
          // Copy existing row cells
          for col in 0..<oldWidth {
            newCells.append(cells[oldRowStart + col])
          }
          
        case .trailing:
          // Copy existing row cells
          for col in 0..<oldWidth {
            newCells.append(cells[oldRowStart + col])
          }
          
          // Add empty cells at end of row
          if delta > 0 {
            for _ in 0..<delta {
              newCells.append(Cell())
            }
          }
      }
    }
    
    width = newWidth
    cells = newCells
  }
  
  private mutating func adjustHeight(edge: GridEdge, delta: Int) {
//    let oldHeight = height
    let newHeight = height + delta
    
    switch edge {
      case .leading:
        if delta > 0 {
          // Add new rows at top
          var newCells: [Cell] = []
          
          // Add new empty rows
          for _ in 0..<delta {
            for _ in 0..<width {
              newCells.append(Cell())
            }
          }
          
          // Add existing cells
          newCells.append(contentsOf: cells)
          cells = newCells
        }
        
      case .trailing:
        if delta > 0 {
          // Add new rows at bottom
          for _ in 0..<(delta * width) {
            cells.append(Cell())
          }
        }
    }
    
    height = newHeight
  }
}

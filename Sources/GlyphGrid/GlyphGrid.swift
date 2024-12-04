//
//  GlyphGrid.swift
//  SwiftBox
//
//  Created by Dave Coleman on 28/8/2024.
//

import Foundation

public struct GlyphGrid: Equatable, Sendable {
  
  public typealias Artwork = [[Character]]
  
  /// Cell should be a product of the selected Font, and Zoom level?
//  public var cell: GlyphCell
  public var cellSize: CGSize
  public var dimensions: GridDimensions
  public var type: GridType
  
  public var artwork: Artwork?

  public static let baseFontSize: CGFloat = 15
  
  public init(
    cellSize: CGSize,
    dimensions: GridDimensions = GridDimensions(),
    type: GridType
  ) {
    self.cellSize = cellSize
    self.dimensions = dimensions
    self.type = type
  }
  
} // END GlyphGrid


//public struct GlyphCell: Equatable, Sendable {
//  
//  public private(set) var font: GridFont
//  public internal(set) var size: CGSize
//  
//  static let example: GlyphCell = .init(
//    font: .menlo,
//    cellWidth: 10,
//    cellHeight: 14
//  )
//  
//  public init(
//    font: GridFont = .sfMono,
//    cellWidth: CGFloat,
//    cellHeight: CGFloat
//  ) {
//    self.font = font
//    self.size = CGSize(width: cellWidth, height: cellHeight)
//  }
//
//}


public struct GridDimensions: Equatable, Sendable {
  
  private var _rows: Int
  private var _columns: Int
  
  public var minValue: Int
  
  public var rows: Int {
    get { _rows }
    set { _rows = max(minValue, newValue) }
  }
  
  public var columns: Int {
    get { _columns }
    set { _columns = max(minValue, newValue) }
  }
  
  public init(
    rows: Int = 2,
    columns: Int = 2,
    minValue: Int = 2
  ) {
    self.minValue = minValue
    self._rows = max(minValue, rows)
    self._columns = max(minValue, columns)
  }
  
  public static let example: GridDimensions = GridDimensions(rows: 20, columns: 10)
}




//
//
//public struct GridDimensions: Equatable, Sendable {
//  public var rows: Int
//  public var columns: Int
//  
//  public init(
//    rows: Int = 10,
//    columns: Int = 10
//  ) {
//    self.rows = rows
//    self.columns = columns
//  }
//  
//  public static let example: GridDimensions = GridDimensions(rows: 20, columns: 10)
//  
//}


/// Now, you can use these structures in your app like this:
///
/// ```swift
/// // In your drawing code
/// if document.selectedCells.contains(glyphGrid.gridPosition(for: somePoint)) {
///   context.fill(glyphGrid.cgRect(for: selectedPosition),
///   with: .color(.blue.opacity(0.3)))
/// }
///
/// // Converting a point to a grid position
/// let position = glyphGrid.gridPosition(for: location)
///
/// // Checking if a position is valid
/// if glyphGrid.isValidPosition(position) {
///   // Do something with the valid position
/// }
/// ```
///

public enum GridType: Equatable, Sendable {
  case canvas(GlyphGrid.Artwork)
  case interface
}



public struct GridPosition: Hashable, Equatable, Sendable {
  public let row: Int
  public let col: Int
  
  public init(
    row: Int = 0,
    col: Int = 0
  ) {
    self.row = row
    self.col = col
  }
  
  
  
}



public enum GridFont: String, CaseIterable, Hashable, Equatable, Sendable, Identifiable {
  
  case menlo = "Menlo"
  case sfMono = "SF Mono"
  case courier = "Courier New"
  case monaco = "Monaco"
  case ibm = "AcPlus IBM BIOS"
  
  public var id: String {
    self.rawValue
  }
  
  public enum NormaliseParameter {
    case fontSize
    case width
    case weight
  }
  
  public struct Normalisers {
    let fontSize: CGFloat
    let width: CGFloat
    let weight: CGFloat
  }
  
  public var normalisers: Normalisers {
    switch self {
      case .menlo:
        Normalisers(
          fontSize: 1.0,
          width: 1.0,
          weight: 1.0
        )
      case .sfMono:
        Normalisers(
          fontSize: 1.0,
          width: 1.0,
          weight: 1.0
        )
      case .courier:
        Normalisers(
          fontSize: 1.1,
          width: 1.0,
          weight: 1.0
        )
      case .monaco:
        Normalisers(
          fontSize: 1.0,
          width: 1.0,
          weight: 1.0
        )
      case .ibm:
        Normalisers(
          fontSize: 0.8,
          width: 1.0,
          weight: 1.0
        )
    }
  }
  
  public func normalised(
    for parameter: NormaliseParameter = .fontSize,
    baseValue: CGFloat
  ) -> CGFloat {
    let factor: CGFloat
    switch parameter {
      case .fontSize:
        factor = normalisers.fontSize
      case .width:
        factor = normalisers.width
      case .weight:
        factor = normalisers.weight
    }
    return baseValue * factor
  }
}

//
//  Model+GridDelta.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 6/8/2025.
//

import Foundation

public struct GridDelta: GridBase {
  public var columns: Int
  public var rows: Int
  
  public init(columns: Int, rows: Int) {
    self.columns = columns
    self.rows = rows
  }
  
  public init(
    old oldDimensions: GridDimensions,
    new newDimensions: GridDimensions
  ) {
    self.init(
      columns: newDimensions.columns - oldDimensions.columns,
      rows: newDimensions.rows - oldDimensions.rows
    )
  }
}
extension GridDelta: CustomStringConvertible {
  public var description: String {
    "GridDelta[C: \(columns), R: \(rows)]"
  }
}

extension GridDelta: CustomDebugStringConvertible {
  public var debugDescription: String {
    let parts = [describeChange(count: columns, singular: "Column", plural: "Columns"),
                 describeChange(count: rows, singular: "Row", plural: "Rows")]
      .compactMap { $0 }
    
    if parts.isEmpty {
      return "GridDelta: No change"
    }
    
    return "GridDelta: " + parts.joined(separator: ", ")
  }
  
  private func describeChange(count: Int, singular: String, plural: String) -> String? {
    guard count != 0 else { return nil }
    
    let action = count > 0 ? "Adding" : "Removing"
    let absCount = abs(count)
    let noun = absCount == 1 ? singular : plural
    
    return "\(action) \(absCount)x \(noun)"
  }
}

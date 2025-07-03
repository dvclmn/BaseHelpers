//
//  Model+Dimensions.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 3/7/2025.
//

public struct GridDimensions: GridBase {
  public var columns: Int
  public var rows: Int
  
  public init(columns: Int, rows: Int) {
    self.columns = columns
    self.rows = rows
  }
}

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
}

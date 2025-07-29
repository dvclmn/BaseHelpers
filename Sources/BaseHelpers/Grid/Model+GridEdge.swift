//
//  Model+GridEdge.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 29/7/2025.
//

import Foundation

public enum GridEdge: GridBase {
  case top
  case trailing
  case bottom
  case leading
  
  public var isRowEdge: Bool {
    self == .top || self == .bottom
  }
  
  public var isColumnEdge: Bool {
    self == .leading || self == .trailing
  }
}

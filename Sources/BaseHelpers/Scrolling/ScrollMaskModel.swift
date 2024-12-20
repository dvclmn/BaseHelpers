//
//  File.swift
//
//
//  Created by Dave Coleman on 11/7/2024.
//

import Foundation
import SwiftUI


/// Will make this optional, and do away with the `maskEnabled`
/// property, as a nil value for a mask config will serve the same purpose.
public struct MaskConfig {
  var mode: MaskMode
  var edge: Edge
  var edgePadding: CGFloat
  var length: CGFloat
  
  public init(
    mode: MaskMode = .mask,
    edge: Edge = .top,
    edgePadding: CGFloat = 30,
    length: CGFloat = 130
  ) {
    self.mode = mode
    self.edge = edge
    self.edgePadding = edgePadding
    self.length = length
  }
}

public struct SafePadding {
  let edges: Edge.Set
  let padding: CGFloat
  
  public init(_ edges: Edge.Set, _ padding: CGFloat) {
    self.edges = edges
    self.padding = padding
  }
}


public enum MaskMode: CaseIterable, Identifiable, Equatable, Sendable {
  
  case mask
  case overlay(opacity: CGFloat = 0.2)
  case off
  
  public static let allCases: [MaskMode] = [.mask, .overlay()]
  
  public var id: String {
    self.name
  }
  
  public var name: String {
    switch self {
      case .mask:
        "Mask"
      case .overlay:
        "Overlay"
        
      case .off:
        "No Masking"
    }
  }
  
  public var opacity: CGFloat {
    switch self {
      case .mask, .off:
        1.0
        
      case .overlay(let opacity):
        opacity

    }
  }
  
}

extension UnitPoint {
  static let halfway = UnitPoint(x: Edge.halfway, y: Edge.halfway)
}


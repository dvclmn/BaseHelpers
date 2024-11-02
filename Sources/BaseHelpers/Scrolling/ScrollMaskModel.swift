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

extension Edge {
  
  static let zero: Double = 0.00
  static let quarter: Double = 0.2
  static let halfway: Double = 0.5
  static let full: Double = 1.0
  
  var off: UnitPoint {
    switch self {
      case .top:
        UnitPoint(x: Edge.halfway, y: Edge.zero)
      case .leading:
        UnitPoint(x: Edge.zero, y: Edge.halfway)
      case .bottom:
        UnitPoint(x: Edge.halfway, y: Edge.full)
      case .trailing:
        UnitPoint(x: Edge.full, y: Edge.halfway)
    }
  }
  
  var on: UnitPoint {
    UnitPoint.halfway
  }
  
  var onQuarter: UnitPoint {
    switch self {
      case .top:
        UnitPoint(x: Edge.halfway, y: Edge.quarter)
      case .leading:
        UnitPoint(x: Edge.quarter, y: Edge.halfway)
      case .bottom:
        UnitPoint(x: Edge.halfway, y: Edge.quarter)
      case .trailing:
        UnitPoint(x: Edge.quarter, y: Edge.halfway)
    }
  }
  
  
  var name: String {
    switch self {
      case .top: "Top"
      case .leading: "Leading"
      case .bottom: "Bottom"
      case .trailing: "Trailing"
    }
  }
  
  var axis: Axis {
    switch self {
      case .top, .bottom: .vertical
      case .leading, .trailing: .horizontal
    }
  }
  var alignment: Alignment {
    switch self {
      case .top: .top
      case .bottom: .bottom
      case .leading: .leading
      case .trailing: .trailing
        
    }
  }
  var edgeSet: Edge.Set {
    switch self {
      case .top: .top
      case .leading: .leading
      case .bottom: .bottom
      case .trailing: .trailing
    }
  }
  
}

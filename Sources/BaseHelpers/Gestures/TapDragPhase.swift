//
//  TapDragPhase.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 14/8/2025.
//

import Foundation

/// Note: Could consider creating a type to encapsulate
/// the `CGPoint`/`CGRect` overlaps, for Taps/Drags.
public enum TapDragPhase: Equatable, Sendable {
  case drag(rect: CGRect)
  case tap(location: CGPoint)
  case ended
  
  public var isDragging: Bool {
    if case .drag(_) = self { true } else { false }
  }
  
  public var isTapping: Bool {
    if case .tap(_) = self { true } else { false }
  }
  
  public var unMappedDragRect: CGRect? {
    switch self {
      case .drag(let rect): rect
      case .tap(_): nil
      case .ended: nil
    }
  }
  
  public var unMappedTapLocation: CGPoint? {
    switch self {
      case .drag(_): nil
      case .ended: nil
      case .tap(let location): location
    }
  }
}

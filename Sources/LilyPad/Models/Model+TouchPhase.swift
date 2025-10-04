//
//  Model+TouchPhase.swift
//  LilyPad
//
//  Created by Dave Coleman on 4/6/2025.
//

import AppKit

public enum TouchPhase: String, Sendable, Equatable, Codable {
  case began
  case moved
  case stationary
  case ended
  case cancelled
  case touching
  case any
}

extension NSTouch.Phase {
  var toDomainPhase: TouchPhase {
    switch self {
      case .began: .began
      case .moved: .moved
      case .stationary: .stationary
      case .ended: .ended
      case .cancelled: .cancelled
      case .touching: .touching
      case .any: .any
      default: .any
    }
  }
  
  var isResting: Bool {
    self == .stationary
  }
}

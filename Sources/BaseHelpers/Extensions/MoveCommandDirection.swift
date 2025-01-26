//
//  MoveCommandDirection.swift
//  Collection
//
//  Created by Dave Coleman on 27/12/2024.
//

#if canImport(AppKit)
import SwiftUI

public extension MoveCommandDirection {
  var name: String {
    switch self {
      case .up: "Up"
      case .down: "Down"
      case .left: "Left"
      case .right: "Right"
      @unknown default: "Unknown"
    }
  }
}
#endif

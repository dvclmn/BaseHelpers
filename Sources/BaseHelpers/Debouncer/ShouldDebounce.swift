//
//  ShouldDebounce.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 15/7/2025.
//

import Foundation

public enum DebounceMode {
  case noDebounce
  case debounce(TimeInterval)

  public var shouldDebounce: Bool {
    switch self {
      case .noDebounce: false
      case .debounce: true
    }
  }
}

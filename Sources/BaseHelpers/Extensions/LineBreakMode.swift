//
//  LineBreakMode.swift
//  Collection
//
//  Created by Dave Coleman on 14/2/2025.
//

#if canImport(AppKit)

import AppKit

public extension NSLineBreakMode {
  
  var displayName: String {
    switch self {
      case .byTruncatingTail: return "Tail Truncation"
      case .byTruncatingMiddle: return "Middle Truncation"
      case .byTruncatingHead: return "Head Truncation"
      case .byWordWrapping: return "Word Wrapping"
      case .byCharWrapping: return "Character Wrapping"
      case .byClipping: return "Clipping"
      @unknown default:
        fatalError("Unknown NSLineBreakMode: \(self)")
    }
  }
}

#endif

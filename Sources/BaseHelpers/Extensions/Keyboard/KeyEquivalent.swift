//
//  KeyEquivalent.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 19/7/2025.
//

import SwiftUI

extension Set where Element == KeyEquivalent {
  public var isHoldingSpace: Bool {
    self.contains(.space)
  }
}

public extension KeyEquivalent {
  
  var name: String {
    switch self {
      case .clear: "Clear"
      case .delete: "Delete"
      case .deleteForward: "Delete Forward"
      case .upArrow: "Up Arrow"
      case .downArrow: "Down Arrow"
      case .leftArrow: "Left Arrow"
      case .rightArrow: "Right Arrow"
      case .escape: "Escape"
      case .home: "Home"
      case .end: "End"
      case .pageUp: "Page Up"
      case .pageDown: "Page Down"
      case .`return`: "Return"
      case .space: "Space"
      case .tab: "Tab"
      case .init(character): "Character: \(character)"
      default: "Unknown"
    }
  }
  
  var symbolLiteral: Character {
    switch self {
      case .clear: "􀆄"
      case .delete: "􁂈"
      case .deleteForward: "􁂒"
      case .upArrow: "􀄤"
      case .downArrow: "􀄥"
      case .leftArrow: "􀄦"
      case .rightArrow: "􀰇"
      case .escape: "􀆧"
      case .home: "􀰹"
      case .end: "􀱈"
      case .pageUp: "􀅃"
      case .pageDown: "􀅄"
      case .`return`: "􀅇"
      case .space: "􁁺"
      case .tab: "􁂎"
      case .init(character): character
      default: "?"
    }
  }
  
  var symbolCapitalised: String {
    String(symbolLiteral).capitalized
  }
  
  var nameAndSymbol: String {
    switch self {
      case .clear, .delete, .deleteForward, .upArrow, .downArrow, .leftArrow, .rightArrow, .escape, .home, .end, .pageUp, .pageDown, .`return`, .space, .tab:
        "\(self.name) (\(self.symbolLiteral))"
        
      default:
        "\(self.name.capitalized)"
    }
  }
  
}

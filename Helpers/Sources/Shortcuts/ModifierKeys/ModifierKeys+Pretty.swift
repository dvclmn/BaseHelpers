//
//  ModifierKeys+Pretty.swift
//  Helpers
//
//  Created by Dave Coleman on 8/9/2024.
//

import AppKit

protocol ModifierRepresentable {
  associatedtype ModifierType: OptionSet where ModifierType.Element == Self
  
  var relevantModifiers: [Self] { get }
  func modifierInfo() -> ModifierInfo
  func toModifierString(ofType type: ModifierSymbolType) -> [String]
}

struct ModifierInfo {
  let symbolName: String
  let symbolLiteral: String
}

enum ModifierSymbolType {
  case name
  case literal
}



extension NSEvent.ModifierFlags: ModifierRepresentable {
  typealias ModifierType = NSEvent.ModifierFlags
  
  var relevantModifiers: [NSEvent.ModifierFlags] {
    return [.shift, .option, .command, .capsLock, .control]
  }
  
  func modifierInfo() -> ModifierInfo {
    switch self {
      case .shift:
        return ModifierInfo(symbolName: "shift", symbolLiteral: "􀆝")
      case .option:
        return ModifierInfo(symbolName: "option", symbolLiteral: "􀆕")
      case .command:
        return ModifierInfo(symbolName: "command", symbolLiteral: "􀆔")
      case .capsLock:
        return ModifierInfo(symbolName: "capslock", symbolLiteral: "􀆡")
      case .control:
        return ModifierInfo(symbolName: "control", symbolLiteral: "􀆍")
      default:
        return ModifierInfo(symbolName: "", symbolLiteral: "")
    }
  }
  
  func toModifierString(ofType type: ModifierSymbolType) -> [String] {
    var modifierStrings = [String]()
    for modifier in relevantModifiers where contains(modifier) {
      let info = modifier.modifierInfo()
      switch type {
        case .name:
          modifierStrings.append(info.symbolName)
        case .literal:
          modifierStrings.append(info.symbolLiteral)
      }
    }
    return modifierStrings
  }
}


public extension NSEvent.ModifierFlags {
  
  struct ModifierInfo {
    let symbolName: String
    let symbolLiteral: String
  }
  
  enum ModifierSymbolType {
    case name
    case literal
  }
  
  private var relevantModifiers: [NSEvent.ModifierFlags] {
    return [.shift, .option, .command, .capsLock, .control]
  }
  
  private var modifierInfo: ModifierInfo {
    switch self {
      case .shift:
        return ModifierInfo(symbolName: "shift", symbolLiteral: "􀆝")
        
      case .option:
        return ModifierInfo(symbolName: "option", symbolLiteral: "􀆕")
        
      case .command:
        return ModifierInfo(symbolName: "command", symbolLiteral: "􀆔")
        
      case .capsLock:
        return ModifierInfo(symbolName: "capslock", symbolLiteral: "􀆡")
        
      case .control:
        return ModifierInfo(symbolName: "control", symbolLiteral: "􀆍")
        
      default:
        return ModifierInfo(symbolName: "", symbolLiteral: "")
    }
  }
  
  func toModifierString(ofType type: ModifierSymbolType = .name) -> [String] {
    
    var modifierStrings = [String]()
    
    for modifier in relevantModifiers where self.contains(modifier) {
      switch type {
        case .name:
          modifierStrings.append(modifier.modifierInfo.symbolName)
        case .literal:
          modifierStrings.append(modifier.modifierInfo.symbolLiteral)
      }
    }
    
    return modifierStrings
  }
  
}

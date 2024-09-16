//
//  Models+Key.swift
//  Helpers
//
//  Created by Dave Coleman on 8/9/2024.
//

#if canImport(AppKit)

extension Keyboard {
  
  //  public struct Key: ShortcutKey {
  //
  //    public let name: String
  //    public let symbolName: String
  //    public let symbolLiteral: String
  //    public let type: Keyboard.KeyType
  //
  //    public init(
  //      name: String,
  //      symbolName: String,
  //      symbolLiteral: String,
  //      type: Keyboard.KeyType
  //    ) {
  //      self.name = name
  //      self.symbolName = symbolName
  //      self.symbolLiteral = symbolLiteral
  //      self.type = type
  //    }
  //
  //  }
  
  public enum Key: ShortcutKey {
    case character(Character)
    case clear
    case delete
    case deleteForward
    case upArrow
    case downArrow
    case leftArrow
    case rightArrow
    case escape
    case home
    case end
    case pageUp
    case pageDown
    case `return`
    case space
    case tab
    
    public var name: String {
      switch self {
        case .character(let character): "\(character)"
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
          
      }
    }
    
    public var symbolName: String {
      switch self {
        case .character(let character): "\(character)"
        case .clear: "xmark"
        case .delete: "delete.backward"
        case .deleteForward: "delete.forward"
        case .upArrow: "arrowtriangle.up"
        case .downArrow: "arrowtriangle.down"
        case .leftArrow: "arrowtriangle.left"
        case .rightArrow: "arrowtriangle.right"
        case .escape: "escape"
        case .home: "arrow.up.left"
        case .end: "arrow.down.right"
        case .pageUp: "arrow.up.to.line.compact"
        case .pageDown: "arrow.down.to.line.compact"
        case .`return`: "return"
        case .space: "space"
        case .tab: "arrow.forward.to.line"
          
      }
    }
    
    public var symbolLiteral: String {
      switch self {
        case .character(let character): "\(character)"
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
      }
    }
    
    public var type: Keyboard.KeyType {
      .key
    }
    
  }
  
}

#endif

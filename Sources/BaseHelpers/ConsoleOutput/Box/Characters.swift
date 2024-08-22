//
//  Characters.swift
//  Helpers
//
//  Created by Dave Coleman on 22/8/2024.
//

import Foundation

extension ConsoleOutput {
  
  /// `─` horizontal
  ///
  /// `┬` horizontal join top
  ///
  /// `┴` horizontal join bottom
  ///
  ///
  /// `│` vertical
  ///
  /// `├` vertical join leading
  ///
  /// `┤` vertical join trailing
  ///
  ///
  /// `┼` cross join
  ///
  ///
  /// `╭` corner top leading
  ///
  /// `╮` corner top trailing
  ///
  /// `╰` corner bottom leading
  ///
  /// `╯` corner bottom trailing
  ///
  
  
  public enum Theme {
    
    case rounded
    case sharp
    case double
    case ascii
    case bold
    case dashed
    
    public var string: String {
      switch self {
        case .rounded:    "─ ┬ ┴ │ ├ ┤ ┼ ╭ ╮ ╰ ╯"
        case .sharp:      "─ ┬ ┴ │ ├ ┤ ┼ ┌ ┐ └ ┘"
        case .double:     "═ ╦ ╩ ║ ╠ ╣ ╬ ╔ ╗ ╚ ╝"
        case .ascii:      "- + + | + + + + + + +"
        case .bold:       "━ ┳ ┻ ┃ ┣ ┫ ╋ ┏ ┓ ┗ ┛"
        case .dashed:     "╌ ┬ ┴ ╎ ├ ┤ ┼ ╭ ╮ ╰ ╯"
      }
    }
  }
  
}


extension Part {
  
  public var themeIndex: Int {
    switch self {
      case .horizontal(join: .none, _):   return 0
      case .horizontal(join: .top, _):    return 2
      case .horizontal(join: .bottom, _): return 4
      case .vertical(join: .none, _):     return 6
      case .vertical(join: .leading, _):  return 8
      case .vertical(join: .trailing, _): return 10
      case .cross:                        return 12
      case .corner(.top(.leading)):       return 14
      case .corner(.top(.trailing)):      return 16
      case .corner(.bottom(.leading)):    return 18
      case .corner(.bottom(.trailing)):   return 20
    }
  }
}

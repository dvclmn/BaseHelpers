//
//  Characters.swift
//  Helpers
//
//  Created by Dave Coleman on 22/8/2024.
//

import Foundation

extension ConsoleOutput {
  
  /// `━` horizontal exterior
  ///
  /// `─` horizontal interior
  ///
  /// `┯` horizontal join top
  ///
  /// `┷` horizontal join bottom
  ///
  ///
  /// `┃` vertical exterior
  ///
  /// `│` vertical interior
  ///
  /// `┠` vertical join leading
  ///
  /// `┨` vertical join trailing
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
        //                 0 0 0 0 0 1 1 1 1 1 2 2 2
        //                 0 2 4 6 8 0 2 4 6 8 0 2 4
        case .rounded:    "━ ─ ┯ ┷ ┃ │ ┠ ┨ ┼ ╭ ╮ ╰ ╯"
          
        case .sharp:      "─ ─ ┬ ┴ │ │ ├ ┤ ┼ ┌ ┐ └ ┘"
          
        case .double:     "═ ─ ╤ ╧ ║ │ ╟ ╢ ┼ ╔ ╗ ╚ ╝"
          
        case .ascii:      "- - + + | | + + + + + + +"
          
        case .bold:       "━ ━ ┳ ┻ ┃ ┃ ┣ ┫ ╋ ┏ ┓ ┗ ┛"
          
        case .dashed:     "╌ ╌ ┬ ┴ ╎ ╎ ├ ┤ ┼ ╭ ╮ ╰ ╯"
          
      }
    }
  }
  
  static let invisibles: String = ""
}


extension Part {
  
  public var themeIndex: Int {
    switch self {
      case .horizontal(join: .none, location: .exterior):   return 0
      case .horizontal(join: .none, location: .interior):   return 2
      case .horizontal(join: .top, _):                      return 4
      case .horizontal(join: .bottom, _):                   return 6
        
      case .vertical(join: .none, location: .exterior):     return 8
      case .vertical(join: .none, location: .interior):     return 10
      case .vertical(join: .leading, _):                    return 12
      case .vertical(join: .trailing, _):                   return 14
        
      case .cross:                                          return 16
        
      case .corner(.top(.leading)):                         return 18
      case .corner(.top(.trailing)):                        return 20
      case .corner(.bottom(.leading)):                      return 22
      case .corner(.bottom(.trailing)):                     return 24
    }
  }
  
  public func character(with config: Config) -> String {
    
    let index = self.themeIndex
    let themeString = config.theme.string
    
    let output: String = String(themeString[themeString.index(themeString.startIndex, offsetBy: index)])
    
    return output
  }
  
  
  
  
}

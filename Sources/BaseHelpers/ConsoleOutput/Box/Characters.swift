//
//  Characters.swift
//  Helpers
//
//  Created by Dave Coleman on 22/8/2024.
//

import Foundation
import SwiftUI

extension SwiftBox {
  
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
  
  public struct Theme {
    
    var set: Theme.GlyphSet
    var styles: Theme.GlyphStyle
    
    public init(
      set: Theme.GlyphSet = .sharp,
      styles: Theme.GlyphStyle = .init()
    ) {
      self.set = set
      self.styles = styles
    }
    
    //    var textForeground: Color {
    //      return colours.text.foreground
    //    }
    //    var invisiblesForeground: Color {
    //      return colours.invisibles.foreground
    //    }
    //    var frameForeground: Color {
    //      return colours.frame.foreground
    //    }
  }
}

extension Theme {
  
  /// `Theme.GlyphSet` and `Theme.GlyphStyle` being seperate
  /// makes sense to me, because the two should operate totally independantly.
  ///
  /// Then having seperate `AttributeContainer`s for pre-defined semantic
  /// 'syntax' seems good too — such as text, invisibles, frames.
  ///
  public struct GlyphStyle {
    
    var text: ColorSet
    var invisibles: ColorSet
    var frame: ColorSet
    
    public init(
      text: ColorSet = .init(foreground: Color.purple.opacity(0.9)),
      accent: ColorSet = .init(foreground: Color.orange.opacity(0.8)),
      invisibles: ColorSet = .init(foreground: Color.secondary.opacity(0.6)),
      frame: ColorSet = .init(foreground: Color.secondary)
    ) {
      self.text = text
      self.invisibles = invisibles
      self.frame = frame
    }
  }
  
  public enum GlyphSet {
    
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
    
  } // END glyph set
  
  public struct BoxStyle {
    var primary: Theme.AttributeSet      // Text
    var secondary: Theme.AttributeSet    // Box frame
    var tertiary: Theme.AttributeSet     // Invisibles
    var accent: Theme.AttributeSet       // Subtle accents
  }
  
  public struct AttributeSet {
    var foreground: Color
    var background: Color
    

  }
  
  public enum Invisibles {
    case line(LineType)
    case space
    case tab
    case padding
    
    public enum LineType {
      case new
      case end
    }
    
    public var character: String {
      switch self {
        case .line(.new): "¬"
        case .line(.end): "¶"
        case .space: "•"
        case .tab: "→"
        case .padding: ","
      }
    }
  }
}


extension Theme.GlyphStyle {
  
  public struct ColorSet {
    var foreground: Color
    var background: Color?
    
    public init(foreground: Color, background: Color? = nil) {
      self.foreground = foreground
      self.background = background
    }
    
    
  }
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
    let themeString = config.theme.set.string
    
    let output: String = String(themeString[themeString.index(themeString.startIndex, offsetBy: index)])
    
    return output
  }
  
  
  
  
}

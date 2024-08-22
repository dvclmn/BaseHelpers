//
//  Models.swift
//  Helpers
//
//  Created by Dave Coleman on 22/8/2024.
//

import Foundation

public typealias Theme = ConsoleOutput.Theme
public typealias Config = ConsoleOutput.BoxConfiguration
public typealias Part = ConsoleOutput.BoxPart
public typealias Structure = ConsoleOutput.BoxStructure
public typealias Line = ConsoleOutput.BoxLine


public struct ConsoleOutput {
  
  
  var header: String
  var content: String
  var config: Config
  
  var attributedString: AttributedString {
    
    var outputString = AttributedString(self.drawBox())
    return outputString
  }
  
  
  public init(
    header: String,
    content: String,
    config: Config = .init()
  ) {
    self.header = header
    self.content = content
    self.config = config
  }
  
  public struct BoxConfiguration {
    var theme: Theme
    var width: Int
    var headerLineLimit: Int?
    var contentLineLimit: Int?
    
    public init(
      theme: Theme = .sharp,
      width: Int = 60,
      headerLineLimit: Int? = 3,
      contentLineLimit: Int? = nil
    ) {
      self.theme = theme
      self.width = width
      self.headerLineLimit = headerLineLimit
      self.contentLineLimit = contentLineLimit
    }
    
    static let `default`: Config = .init()
  }
  
  /// Currently this implementaiton can only handle horizontal dividers, not vertical.
  /// So we can process line-by-line vertically in a fairly straightforward way.
  ///
  public enum BoxLine {
    case top
    case header
    case divider
    case content
    case bottom
  }

  public enum BoxStructure {
    
    case horizontal(Structure.Horizontal)
    case vertical(Structure.Vertical)
    
    public enum Horizontal {
      case top
      case divider
      case bottom
      
      public var corners: (Part, Part)? {
        switch self {
          case .top:
            (Part.corner(.top(.leading)), Part.corner(.top(.trailing)))
          case .divider:
            nil
          case .bottom:
            (Part.corner(.bottom(.leading)), Part.corner(.bottom(.trailing)))
        }
      }

    }
    
    public enum Vertical {
      case leading
      case divider
      case trailing
    }
    
  }
  
  public enum BoxPart: Hashable {
    
    case horizontal(
      join: Join.Horizontal = .none,
      location: Location = .exterior
    )
    
    case vertical(
      join: Join.Vertical = .none,
      location: Location = .exterior
    )
    case cross
    
    case corner(Corner)
    
    public enum Join {
      

      public enum Horizontal: Hashable {
        
        case none

        /// ┯
        case top
        
        /// ┷
        case bottom
      }
      
      public enum Vertical: Hashable {
      
        case none
        
        /// ┠
        case leading
        
        /// ┨
        case trailing
      }
      
    }
    
    public enum Corner: Hashable {
      
      case top(Top)
      case bottom(Bottom)
      
      public enum Top {
        /// ┏
        case leading
        
        /// ┓
        case trailing
        
      }
      
      public enum Bottom {
        /// ┗
        case leading
        
        /// ┛
        case trailing
        
      }
    }
    
    public enum Location {
      case interior
      case exterior
    }
     
  }
}

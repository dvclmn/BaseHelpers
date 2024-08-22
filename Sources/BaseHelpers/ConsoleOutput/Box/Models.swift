//
//  Models.swift
//  Helpers
//
//  Created by Dave Coleman on 22/8/2024.
//

import Foundation

public typealias Style = ConsoleOutput.BoxStyle
public typealias Part = ConsoleOutput.BoxPart
public typealias Structure = ConsoleOutput.BoxStructure

public struct ConsoleOutput {
  
  public let theme: Theme
  
  public init(theme: Theme = .rounded) {
    self.theme = theme
  }

  public enum BoxStyle: String, CaseIterable {
    case rounded
    case sharp
    case double
    case ascii
    case stars
    case hearts
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

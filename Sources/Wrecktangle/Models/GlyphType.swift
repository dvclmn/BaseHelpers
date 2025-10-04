//
//  PartType.swift
//  BoxCore
//
//  Created by Dave Coleman on 13/9/2024.
//


public extension BoxCore {
  
  enum JoinType: Hashable, Sendable {
    case leading
    case trailing
    case top
    case bottom
    case cross
    
    
  }
  
  enum CornerType: Hashable, Sendable {
    case topLeading
    case topTrailing
    case bottomLeading
    case bottomTrailing
  }
  
  /// I ought to make it so the code will use the external version of a glyph,
  /// if there is no internal style available?
  ///
  enum GlyphType: Hashable, Sendable {
    
    /// Basic lines
    case horizontal(Location = .exterior)
    case vertical(Location = .exterior)
    
    /// Joins
    case join(
      x: Location = .interior,
      y: Location = .exterior,
      type: JoinType
    )
    
    /// Corners
    case corner(
      location: Location = .exterior,
      type: CornerType
    )
    
    case blank
    
    public enum Location: Hashable, Sendable {
      case interior
      case exterior
    }
    
    var fallback: BoxCore.GlyphType? {
      switch self {
        case .horizontal(.interior):
          return .horizontal(.exterior)
        case .vertical(.interior):
          return .vertical(.exterior)
        case .join(_, _, let type):
          return .join(x: .exterior, y: .exterior, type: type) // Default to cross join
        case .corner(_, let type):
          return .corner(location: .exterior, type: type) // Default to top-leading corner
          
        default:
          return nil
      }
    }
  }
    
}

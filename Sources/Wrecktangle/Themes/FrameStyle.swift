//
//  FrameStyle.swift
//  BoxCore
//
//  Created by Dave Coleman on 24/8/2024.
//

public extension BoxCore.Theme {
  
  enum FrameStyle: Sendable {
    case single
    case double
    
    /// Not yet implemented
//    case intertwined

    /// This property forms a 'promise' that no single `BoxPart` should
    /// exceed either dimension (width or height) for the given
    /// `FrameStyle`, as defined below.
    ///
    /// This can also be thought of like a tile size. Any `BoxPart`
    /// exceeding this tile size is likely to break the layout in some way.
    ///
    public var maximumGridSize: BoxCore.Dimensions {
      
      let dimensions: BoxCore.Dimensions
      
      switch self {
        case .single:
          
          /// # Single — 1x1
          ///
          /// ```
          /// // Top leading corner
          ///   1
          /// 1 ┌
          ///
          /// //Bottom centre join
          ///   1
          /// 1 ╧
          ///
          /// ```
          ///
          let width: Int = 1 + 1 // One character either side
          let height: Int = 1
          
          dimensions = .init(width, height)

          
        case .double:
          
          /// # Double — 3x2
          ///
          /// ```
          /// // Top leading corner, 3x2
          ///
          ///   123
          /// 1 ┏━━
          /// 2 ┃ ┏
          ///
          ///
          /// // Bottom centre join 1x2
          /// // Does not exceed 3x2
          ///
          ///   1
          /// 1 ┷
          /// 2 ═
          ///
          /// ```
          ///
          let width: Int = 3 + 3 // One character either side
          let height: Int = 2
          
          dimensions = .init(width, height)
          
      }
      
      return dimensions
    }

  }
}

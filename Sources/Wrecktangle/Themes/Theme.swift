//
//  Themes.swift
//  Helpers
//
//  Created by Dave Coleman on 23/8/2024.
//

import SwiftUI

public extension BoxCore {
  
  struct Theme: Sendable {
    
    public var glyphSet: GlyphSet
    
    /// This is only relevant for SwiftUI views, not the console output
//    internal var colour: ColourSet
    public var frameStyle: FrameStyle
//    internal var shadow: Shadow
    public var padding: Int
    
    public init(
      glyphSet: GlyphSet = .rounded,
//      colour: ColourSet = .default,
      frameStyle: FrameStyle = .single,
//      shadow: Shadow = Shadow(),
      padding: Int = 1
    ) {
      self.glyphSet = glyphSet
//      self.colour = colour
      self.frameStyle = frameStyle
//      self.shadow = shadow
      self.padding = padding
    }
  }
}

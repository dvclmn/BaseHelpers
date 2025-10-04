//
//  BoxCore+Init.swift
//  BoxCore
//
//  Created by Dave Coleman on 16/9/2024.
//

import BaseHelpers

public extension BoxCore {
  
  init(
    header: String,
    content: String,
    width: Int,
    glyphSet: BoxCore.GlyphSet,
    frameStyle: BoxCore.Theme.FrameStyle,
    widthCounter: TextCore.WidthCounterStyle
  ) {
    let theme = BoxCore.Theme(
      glyphSet: glyphSet,
      frameStyle: frameStyle,
      padding: 1
    )
    
    let metrics = BoxCore.Config.Metrics(
      widthCounter: widthCounter,
      lineNumbers: false,
      invisibles: false
    )
    
    let config = BoxCore.Config(
      theme: theme,
      width: width,
      headerLineLimit: 2,
      contentLineLimit: 8,
      wordWrapStrategy: .hyphenate,
      metrics: metrics
    )
    
    self.header = header
    self.content = content
    self.config = config
    
    
  }

}

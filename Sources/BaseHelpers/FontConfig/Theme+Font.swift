//
//  Theme+Font.swift
//  SwiftDown
//
//  Created by Dave Coleman on 26/2/2025.
//

import NSUI

extension MarkdownTheme.Fonts {
  public subscript(type: Markdown.Syntax) -> FontConfig {
    get { fonts[type] ?? .system(size: 14) }
    set { fonts[type] = newValue }
  }

  public func with(_ type: Markdown.Syntax, size: CGFloat) -> Self {
    var copy = self
    var fontConfig = copy[type]
    fontConfig.setSize(size)
    copy[type] = fontConfig
    return copy
  }
  
  public func with(_ type: Markdown.Syntax, weight: NSUIFont.Weight) -> Self {
    var copy = self
    var fontConfig = copy[type]
    fontConfig.setWeight(weight)
    copy[type] = fontConfig
    return copy
  }
}




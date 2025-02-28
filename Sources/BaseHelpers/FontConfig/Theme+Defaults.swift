//
//  ThemeStyles.swift
//  SwiftDown
//
//  Created by Dave Coleman on 26/2/2025.
//

#if os(macOS)
import AppKit



extension Markdown.Syntax {
  
  public var defaultColor: NSColor {
    switch self {
      case .quoteBlock: .labelColor
      case .list: .labelColor
      case .codeBlock: .systemBrown
      case .heading: .textColor
      case .inlineCode: .systemBrown
      case .italic: .systemIndigo
      case .bold: .systemMint
      case .link: .labelColor
      case .image: .labelColor
      case .body: .labelColor
      case .boldItalic: .systemGray
      case .strikethrough: .systemGray
      case .highlight: .systemOrange
      case .horizontalRule: . systemPurple
    }
  }

  public var defaultStyle: FontStyleType {
    switch self {
      case .quoteBlock: .body
      case .list: .body
      case .codeBlock: .monospaced
      case .heading: .bold
      case .inlineCode: .bold
      case .italic: .monospaced
      case .bold: .bold
      case .link: .bold
      case .image: .bold
      case .body: .body
      case .boldItalic: .italic
      case .strikethrough: .bold
      case .highlight: .body
      case .horizontalRule: .body

    }
  }
  
  public func defaultFont(withSize size: CGFloat = 14) -> FontConfig {
    defaultStyle.preset(withSize: size)
  }

}

#endif

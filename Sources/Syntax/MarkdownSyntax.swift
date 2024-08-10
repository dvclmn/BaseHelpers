//
//  File.swift
//
//
//  Created by Dave Coleman on 10/8/2024.
//


import Foundation
import SwiftUI
import RegexBuilder


public typealias SymbolicTraits = NSFontDescriptor.SymbolicTraits

public struct TextFormattingRule {
   public typealias AttributedKeyCallback = (String, Range<String.Index>) -> Any
   
   public let key: NSAttributedString.Key?
   public let calculateValue: AttributedKeyCallback?
   public let fontTraits: SymbolicTraits
   
   // Convenience initialisers
   
   public init(key: NSAttributedString.Key, value: Any) {
      self.init(key: key, calculateValue: { _, _ in value }, fontTraits: [])
   }
   
   public init(key: NSAttributedString.Key, calculateValue: @escaping AttributedKeyCallback) {
      self.init(key: key, calculateValue: calculateValue, fontTraits: [])
   }
   
   public init(fontTraits: SymbolicTraits) {
      self.init(key: nil, calculateValue: nil, fontTraits: fontTraits)
   }
   
   // Fully-featured initialiser
   public init(
      key: NSAttributedString.Key? = nil,
      calculateValue: AttributedKeyCallback? = nil,
      fontTraits: SymbolicTraits = []
   ) {
      self.key = key
      self.calculateValue = calculateValue
      self.fontTraits = fontTraits
   }
}


public enum MarkdownSyntax: CaseIterable, Identifiable, Equatable, Hashable {
   public static var allCases: [MarkdownSyntax] = []
   
   
//   case heading(level: Int)
   case h1
   case bold
   case boldAlt
   case italic
   case italicAlt
   case boldItalic
   case strikethrough
   case highlight
   case inlineCode
   case codeBlock
   case quoteBlock
   
   nonisolated public var id: String {
      self.name
   }
   
   public var name: String {
      switch self {
//         case .heading(let level):
//            "H\(level)"
         case .h1:
            "Heading 1"
         case .bold, .boldAlt:
            "Bold"
            
         case .italic, .italicAlt:
            "Italic"
            
         case .boldItalic:
            "Bold Italic"
            
         case .strikethrough:
            "Strikethrough"
            
         case .highlight:
            "Highlight"
            
         case .inlineCode:
            "Inline code"
            
         case .codeBlock:
            "Code block"
            
         case .quoteBlock:
            "Quote block"
            
      }
   }
   
//   private static let regexPatterns: [MarkdownSyntax: String] = [
////      .heading: "# (.*)",
//      .h1: "# (.*)",
//      .bold: "\\*\\*(.*?)\\*\\*",
//      .boldAlt: "\\_\\_(.*?)\\_\\_",
//      .italic: "\\*(.*?)\\*",
//      .italicAlt: "\\_(.*?)\\_",
//      .boldItalic: "\\*\\*\\*(.*?)\\*\\*\\*",
//      .strikethrough: "~~(.*?)~~",
//      .inlineCode: "`([^\\n`]+)(?!``)`(?!`)",
//      .codeBlock: "^\\s*```([\\s\\S]*?)^\\s*```"
//   ]
   
//   private static let regexCache: [MarkdownSyntax: NSRegularExpression] = {
//      var cache = [MarkdownSyntax: NSRegularExpression]()
//      for (syntax, pattern) in regexPatterns {
//         do {
//            let regex = try NSRegularExpression(pattern: pattern, options: syntax == .codeBlock ? .anchorsMatchLines : [])
//            cache[syntax] = regex
//         } catch {
//            print("Error creating regex for \(syntax): \(error)")
//         }
//      }
//      return cache
//   }()
//   
//   public var pattern: NSRegularExpression? {
//      return MarkdownSyntax.regexCache[self]
//   }
//   
   public var formatting: [TextFormattingRule] {
      switch self {

            
//         case .boldItalic:
//            <#code#>
//         case .strikethrough:
//            <#code#>
//         case .inlineCode:
//            <#code#>
//         case .codeBlock:
//            <#code#>
//         case .quoteBlock:
//            <#code#>
            
         default: [TextFormattingRule(fontTraits: self.fontTraits)]
      }
   }
   
   public var fontTraits: NSFontDescriptor.SymbolicTraits {
      switch self {
         case .h1:
            [.bold]
            
         case .bold, .boldAlt:
            [.bold]
            
         case .italic, .italicAlt:
            [.italic]
            
         case .boldItalic:
            [.bold, .italic]
            
         default: []
            
      }
   }
   
//   public var regexLiteral: Regex<(Substring, Substring)> {
//      switch self {
//         case .h1:
//            /# (.*)/
//         case .bold, .boldAlt:
//            /\*\*(.*?)\*\*/
//         case .italic, .italicAlt:
//            /\*(.*?)\*/
//         case .boldItalic:
//            /\*\*\*(.*?)\*\*\*/
//         case .strikethrough:
//            /\~\~(.*?)\~\~/
//         case .inlineCode:
//            /`([^\n`]+)(?!``)`(?!`)/
//         case .codeBlock:
//            /(?m)^```([\s\S]*?)^```/
//         case .quoteBlock:
//            /(?m)^>([\s\S]*?)/
//      }
//   }
   
   public var pattern: String {
      switch self {
         case .h1:
            "^#{1,6}\\s.*$"
            
         case .bold, .boldAlt:
            "((\\*|_){2})((?!\\1).)+\\1"
            
         case .italic, .italicAlt:
            "(?<!_)_[^_]+_(?!\\*)"
            
         case .boldItalic:
            "(\\*){3}((?!\\1).)+\\1{3}"
            
         case .strikethrough:
            "(~)((?!\\1).)+\\1"
            
         case .highlight:
            "(==)((?!\\1).)+\\1"
            
            
         case .inlineCode:
            "`[^`]*`"
            
         case .codeBlock:
            "(`){3}((?!\\1).)+\\1{3}"
            
         case .quoteBlock:
            "^>.*"
      }
   }
   
   public var patternOptions: NSRegularExpression.Options {
      switch self {
         case .h1, .strikethrough, .highlight:
            [.anchorsMatchLines]
            
         case .bold, .boldAlt, .italic, .italicAlt, .boldItalic, .inlineCode:
            []

         case .codeBlock:
            [.dotMatchesLineSeparators]
            
         case .quoteBlock:
            [.anchorsMatchLines]
      }
   }
   
   
   public var type: SyntaxType {
      switch self {
         case .h1:
               .line
         case .codeBlock, .quoteBlock:
               .block
         default:
               .inline
      }
   }
   
   public var hideSyntax: Bool {
      switch self {
         case .bold:
            true
         default:
            false
      }
   }
   
   public var syntaxCharacters: String {
      switch self {
         case .h1:
            "#"
         case .bold:
            "**"
         case .boldAlt:
            "__"
         case .italic:
            "*"
         case .italicAlt:
            "_"
         case .boldItalic:
            "***"
         case .strikethrough:
            "~~"
         case .highlight:
            "=="
            
         case .inlineCode:
            "`"
         case .codeBlock:
            "```"
         case .quoteBlock:
            ">"
      }
   }
   
   public var syntaxCharacterCount: Int? {
      self.syntaxCharacters.count
   }
   
//   public var isSyntaxSymmetrical: Bool {
//      switch self {
//         case .heading, .quoteBlock:
//            false
//         default:
//            true
//      }
//   }
//   
   public var shortcut: KeyboardShortcut? {
      switch self {
            
//         case .heading(let level):
//               .init("\(level)", modifiers: [.command])
         case .bold, .boldAlt:
               .init("b", modifiers: [.command])
         case .italic, .italicAlt:
               .init("i", modifiers: [.command])
         case .boldItalic:
               .init("b", modifiers: [.command, .shift])
         case .strikethrough:
               .init("u", modifiers: [.command])
         case .inlineCode:
               .init("c", modifiers: [.command, .option])
         case .codeBlock:
               .init("k", modifiers: [.command, .shift])
         default:
            nil
      }
   }
   
   public var fontSize: Double {
      switch self {
         case .inlineCode, .codeBlock:
            14
         default: MarkdownDefaults.fontSize
      }
   }
   public var foreGroundColor: NSColor {
      switch self {
         default:
               .textColor.withAlphaComponent(0.85)
      }
   }
   
   public var contentAttributes: [NSAttributedString.Key : Any] {
      
      switch self {
            
            //         case .body:
            //            return [
            //               .font: NSFont.systemFont(ofSize: self.fontSize, weight: .medium),
            //               .foregroundColor: self.foreGroundColor,
            //               .backgroundColor: NSColor.clear
            //            ]
         case .h1:
            return [
               .font: NSFont.systemFont(ofSize: self.fontSize, weight: .medium),
               .foregroundColor: self.foreGroundColor,
               .backgroundColor: NSColor.clear
               
            ]
            //
            //         case .h2:
            //
            //            return [
            //               .font: NSFont.systemFont(ofSize: self.fontSize, weight: .medium),
            //               .foregroundColor: self.foreGroundColor,
            //               .backgroundColor: NSColor.clear
            //            ]
            //
            //         case .h3:
            //            return [
            //               .font: NSFont.systemFont(ofSize: self.fontSize, weight: .medium),
            //               .foregroundColor: self.foreGroundColor,
            //               .backgroundColor: NSColor.clear
            //            ]
            //
         case .bold, .boldAlt:
            return [
               .font: NSFont.systemFont(ofSize: self.fontSize, weight: .bold),
               .foregroundColor: self.foreGroundColor,
               .backgroundColor: NSColor.clear
            ]
            
         case .italic, .italicAlt:
            let bodyDescriptor = NSFontDescriptor.preferredFontDescriptor(forTextStyle: .body)
            let italicDescriptor = bodyDescriptor.withSymbolicTraits(.italic)
            let mediumWeightDescriptor = italicDescriptor.addingAttributes([
               .traits: [
                  NSFontDescriptor.TraitKey.weight: NSFont.Weight.medium
               ]
            ])
            let font = NSFont(descriptor: mediumWeightDescriptor, size: self.fontSize)
            return [
               .font: font as Any,
               .foregroundColor: self.foreGroundColor,
               .backgroundColor: NSColor.clear
            ]
            
         case .boldItalic:
            let bodyDescriptor = NSFontDescriptor.preferredFontDescriptor(forTextStyle: .body)
            let font = NSFont(descriptor: bodyDescriptor.withSymbolicTraits([.italic, .bold]), size: self.fontSize)
            return [
               .font: font as Any,
               .foregroundColor: self.foreGroundColor,
               .backgroundColor: NSColor.clear
            ]
            
         case .strikethrough:
            return [
               .font: NSFont.systemFont(ofSize: self.fontSize, weight: .medium),
               .foregroundColor: self.foreGroundColor,
               .backgroundColor: NSColor.yellow
            ]
            
         case .highlight:
            return [
               .font: NSFont.systemFont(ofSize: self.fontSize, weight: .medium),
               .foregroundColor: self.foreGroundColor,
               .strikethroughStyle: NSUnderlineStyle.single.rawValue,
               .backgroundColor: NSColor.clear
            ]
            
         case .inlineCode:
            return [
               .font: NSFont.monospacedSystemFont(ofSize: self.fontSize, weight: .medium),
               .foregroundColor: self.foreGroundColor,
               .backgroundColor: NSColor.black.withAlphaComponent(MarkdownDefaults.backgroundInlineCode)
            ]
         case .codeBlock:
            return [
               .font: NSFont.monospacedSystemFont(ofSize: self.fontSize, weight: .medium),
               .foregroundColor: self.foreGroundColor,
               .backgroundColor: NSColor.black.withAlphaComponent(MarkdownDefaults.backgroundCodeBlock)
            ]
            
         case .quoteBlock:
            return [
               .font: NSFont.monospacedSystemFont(ofSize: self.fontSize, weight: .medium),
               .foregroundColor: self.foreGroundColor,
               .backgroundColor: NSColor.black.withAlphaComponent(MarkdownDefaults.backgroundCodeBlock)
            ]
      }
   } // END content attributes
   
   public var syntaxAttributes: [NSAttributedString.Key : Any]  {
      
      switch self {
            
         case .inlineCode:
            return [
               .font: NSFont.monospacedSystemFont(ofSize: self.fontSize, weight: .regular),
               .foregroundColor: NSColor.textColor.withAlphaComponent(MarkdownDefaults.syntaxAlpha),
               .backgroundColor: NSColor.black.withAlphaComponent(MarkdownDefaults.backgroundInlineCode)
            ]
         case .codeBlock:
            return [
               .font: NSFont.monospacedSystemFont(ofSize: self.fontSize, weight: .regular),
               .foregroundColor: NSColor.textColor.withAlphaComponent(MarkdownDefaults.syntaxAlpha),
               .backgroundColor: NSColor.black.withAlphaComponent(MarkdownDefaults.backgroundCodeBlock)
            ]
         default:
            return [
               .font: NSFont.monospacedSystemFont(ofSize: self.fontSize, weight: .regular),
               .foregroundColor: NSColor.textColor.withAlphaComponent(MarkdownDefaults.syntaxAlpha),
               .backgroundColor: NSColor.clear
            ]
      }
   }
}

enum CodeLanguage {
   case swift
   case python
}

enum SyntaxComponent {
   case open
   case content
   case close
}

public enum SyntaxType {
   case block
   case line
   case inline
}




public struct MarkdownEditorConfiguration {
   public var fontSize: Double
   public var fontWeight: NSFont.Weight
   public var insertionPointColour: Color
   public var codeColour: Color
   public var paddingX: Double
   public var paddingY: Double
   
   public init(
      fontSize: Double = MarkdownDefaults.fontSize,
      fontWeight: NSFont.Weight = MarkdownDefaults.fontWeight,
      insertionPointColour: Color = .blue,
      codeColour: Color = .primary.opacity(0.7),
      paddingX: Double = MarkdownDefaults.paddingX,
      paddingY: Double = MarkdownDefaults.paddingY
   ) {
      self.fontSize = fontSize
      self.fontWeight = fontWeight
      self.insertionPointColour = insertionPointColour
      self.codeColour = codeColour
      self.paddingX = paddingX
      self.paddingY = paddingY
   }
}





public struct MarkdownDefaults {
   
   public static let defaultFont =               NSFont.systemFont(ofSize: MarkdownDefaults.fontSize, weight: MarkdownDefaults.fontWeight)
   public static let fontSize:                 Double = 15
   public static let fontWeight:               NSFont.Weight = .regular
   public static let fontOpacity:              Double = 0.85
   
   public static let headerSyntaxSize:         Double = 20
   
   public static let fontSizeMono:             Double = 14.5
   
   public static let syntaxAlpha:              Double = 0.3
   public static let backgroundInlineCode:     Double = 0.2
   public static let backgroundCodeBlock:      Double = 0.4
   
   public static let lineSpacing:              Double = 6
   public static let paragraphSpacing:         Double = 0
   
   public static let paddingX: Double = 30
   public static let paddingY: Double = 30
}

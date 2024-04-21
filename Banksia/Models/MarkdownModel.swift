//
//  MarkdownModel.swift
//  Banksia
//
//  Created by Dave Coleman on 20/4/2024.
//

import Foundation
import SwiftUI
import Styles

struct MarkdownDefaults {
    static let fontSize: Double = 15
}

enum MarkdownSyntax: String, CaseIterable {
    case h1
    case h2
    case h3
    case bold
    case italic
    case boldItalic
    case strikethrough
    case inlineCode
    case codeBlock
    
    var name: String {
        self.rawValue
    }
    /// https://swiftregex.com
    var regex: Regex<(Substring, Substring)> {
        switch self {
        case .h1:
            return /#(.*)/
        case .h2:
            return /##(.*)/
        case .h3:
            return /###(.*)/
        case .bold:
            return /\*\*(.*?)\*\*/
        case .italic:
            return /\*(.*?)\*/
        case .boldItalic:
            return /\*\*\*(.*?)\*\*\*/
        case .strikethrough:
            return /\~\~(.*?)\~\~/
        case .inlineCode:
            //            return /`(.*?)`/
            return /`([^\n`]+)(?!``)`(?!`)/
        case .codeBlock:
            return /(?m)^```([\s\S]*?)```/
        }
    }
    
    var hideSyntax: Bool {
        switch self {
        case .h1:
            true
        case .h2:
            false
        case .h3:
            false
        case .bold:
            false
        case .italic:
            false
        case .boldItalic:
            false
        case .strikethrough:
            false
        case .inlineCode:
            false
        case .codeBlock:
            false
        }
    }
    /// Used to specify the capture group to target, for styling.
    /// 0 = entire match (all groups), 1 = first group, 2 = second group, and so on
    //    var captureGroup: Int {
    //        switch self {
    //        case .codeBlock: 2
    //        default: 1
    //        }
    //    }
    var syntaxCharacters: Int {
        switch self {
        case .h1: 1
        case .h2: 2
        case .h3: 3
        case .bold: 2
        case .italic: 1
        case .boldItalic: 3
        case .strikethrough: 2
        case .inlineCode: 1
        case .codeBlock: 3
        }
    }
    var syntaxSymmetrical: Bool {
        switch self {
        case .h1, .h2, .h3:
            false
        default:
            true
        }
    }
    var fontSize: Double {
        switch self {
        case .h1:
            28
        case .h2:
            24
        case .h3:
            18
        case .inlineCode, .codeBlock:
            14
        default: MarkdownDefaults.fontSize
        }
    }
    var foreGroundColor: Color {
        switch self {
        case .inlineCode, .codeBlock:
                .eggplant
        default:
                .primary
        }
    }
    
    var contentAttributes: [NSAttributedString.Key : Any] {
        switch self {
        case .h1:
            return [
                .font: NSFont.systemFont(ofSize: self.fontSize, weight: .medium),
                .foregroundColor: NSColor.textColor
            ]
            
        case .h2:
            
            return [
                .font: NSFont.systemFont(ofSize: self.fontSize, weight: .medium),
                .foregroundColor: NSColor.textColor
            ]
            
        case .h3:
            return [
                .font: NSFont.systemFont(ofSize: self.fontSize, weight: .medium),
                .foregroundColor: NSColor.textColor
            ]
            
        case .bold:
            return [
                .font: NSFont.systemFont(ofSize: self.fontSize, weight: .bold),
                .foregroundColor: NSColor.textColor
            ]
            
        case .italic:
            let bodyDescriptor = NSFontDescriptor.preferredFontDescriptor(forTextStyle: .body)
            let font = NSFont(descriptor: bodyDescriptor.withSymbolicTraits(.italic), size: self.fontSize)
            return [
                .font: font as Any,
                .foregroundColor: NSColor.textColor
            ]
            
        case .boldItalic:
            let bodyDescriptor = NSFontDescriptor.preferredFontDescriptor(forTextStyle: .body)
            let font = NSFont(descriptor: bodyDescriptor.withSymbolicTraits([.italic, .bold]), size: self.fontSize)
            return [
                .font: font as Any,
                .foregroundColor: NSColor.textColor
            ]
            
        case .strikethrough:
            return [
                .font: NSFont.systemFont(ofSize: self.fontSize, weight: .medium),
                .foregroundColor: NSColor.textColor,
                .strikethroughStyle: NSUnderlineStyle.single.rawValue
            ]
            
        case .inlineCode, .codeBlock:
            return [
                .font: NSFont.monospacedSystemFont(ofSize: self.fontSize, weight: .medium),
                .foregroundColor: NSColor.eggplant,
                .backgroundColor: NSColor.white.withAlphaComponent(Styles.backgroundAlpha)
            ]
        }
    } // END content attributes
    
    var syntaxAttributes: [NSAttributedString.Key : Any]  {
        switch self {
        case .h1:
            
            return [
                .font: NSFont.systemFont(ofSize: self.fontSize, weight: .light),
                .foregroundColor: NSColor.textColor.withAlphaComponent(Styles.syntaxAlpha)
            ]
        case .h2:
            return [
                .font: NSFont.systemFont(ofSize: self.fontSize, weight: .light),
                .foregroundColor: NSColor.textColor.withAlphaComponent(Styles.syntaxAlpha)
            ]
        case .h3:
            return [
                .font: NSFont.systemFont(ofSize: self.fontSize, weight: .light),
                .foregroundColor: NSColor.textColor.withAlphaComponent(Styles.syntaxAlpha)
            ]
        case .bold, .italic, .boldItalic, .strikethrough:
            return [
                .font: NSFont.systemFont(ofSize: self.fontSize, weight: .regular),
                .foregroundColor: NSColor.textColor.withAlphaComponent(Styles.syntaxAlpha)
            ]
        case.inlineCode, .codeBlock:
            return [
                .font: NSFont.systemFont(ofSize: self.fontSize, weight: .regular),
                .foregroundColor: NSColor.textColor.withAlphaComponent(Styles.syntaxAlpha),
//                .backgroundColor: NSColor.white.withAlphaComponent(Styles.backgroundAlpha)
            ]
            
        }
    }
}

enum CodeLanguage {
    case swift
    case python
}

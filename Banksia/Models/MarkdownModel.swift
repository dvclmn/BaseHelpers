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
            return /`([^`]+)(?!``)`(?!`)/
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
    
    var contentAttributes: MarkdownStyleAttributes {
        switch self {
        case .h1:
            MarkdownStyleAttributes(
                fontSize: self.fontSize
            )
            
        case .h2:
            MarkdownStyleAttributes(
                fontSize: self.fontSize
            )
            
        case .h3:
            MarkdownStyleAttributes(
                fontSize: self.fontSize,
                fontWeight: .medium
            )
            
        case .bold:
            MarkdownStyleAttributes(
                fontWeight: .bold
            )
        case .italic:
            MarkdownStyleAttributes(isItalic: true)
            
        case .boldItalic:
            MarkdownStyleAttributes(
                fontWeight: .bold,
                isItalic: true
            )
        case .strikethrough:
            MarkdownStyleAttributes(hasStrike: true)
            
        case .inlineCode, .codeBlock:
            MarkdownStyleAttributes(
                fontSize: self.fontSize,
                fontWeight: .medium,
                isMono: true,
                foregroundColor: .eggplant,
                backgroundColour: .white
            )
            
        }
    } // END content attributes
    
    var syntaxAttributes: MarkdownStyleAttributes {
        switch self {
        case .h1:
            MarkdownStyleAttributes(
                fontSize: self.fontSize,
                fontWeight: .light,
                foregroundOpacity: 0.3
            )
        case .h2:
            MarkdownStyleAttributes(
                fontSize: self.fontSize,
                fontWeight: .light,
                foregroundOpacity: 0.3
            )
        case .h3:
            MarkdownStyleAttributes(
                fontSize: self.fontSize,
                fontWeight: .light,
                foregroundOpacity: 0.3
            )
        case .bold, .italic, .boldItalic, .strikethrough:
            MarkdownStyleAttributes(foregroundOpacity: 0.3)
        case.inlineCode, .codeBlock:
            MarkdownStyleAttributes(
                fontWeight: .bold,
                foregroundOpacity: 0.2,
                backgroundColour: .white
            )
            
        }
    }
}


struct MarkdownStyleAttributes {
    var fontSize: Double = MarkdownDefaults.fontSize
    var fontWeight: NSFont.Weight = .regular
    var isMono: Bool = false
    var isItalic: Bool = false
    var foregroundColor: NSColor = .textColor
    var foregroundOpacity: Double = 0.8
    var backgroundColour: NSColor = .clear
    var backgroundOpacity: Double = 0.07
    var hasStrike: Bool = false
}

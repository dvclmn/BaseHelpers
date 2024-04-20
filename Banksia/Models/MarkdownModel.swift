//
//  MarkdownModel.swift
//  Banksia
//
//  Created by Dave Coleman on 20/4/2024.
//

import Foundation
import SwiftUI
import Styles


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
            return /`(?!`)(.*?)`/
        case .codeBlock:
            return /```(.*?)```/
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
    
    var contentRange: Int {
        switch self {
        case .codeBlock: 2
        default: 1
        }
    }
    var syntaxRangeLocation: Int {
        switch self {
        case .h1: -1
        case .h2: -2
        case .h3: -3
        case .bold: -2
        case .italic: -1
        case .boldItalic: -1
        case .strikethrough: -2
        case .inlineCode: -1
        case .codeBlock: -4
        }
    }
    
    var syntaxRangeLength: Int {
        switch self {
        case .bold: 4
        case .italic: 2
        case .boldItalic: 2
        case .strikethrough: 4
        case .inlineCode: 2
        case .codeBlock: 9
        default: 0
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
        default: 15
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
    var fontSize: Double = 15
    var fontWeight: NSFont.Weight = .regular
    var isMono: Bool = false
    var isItalic: Bool = false
    var foregroundColor: NSColor = .textColor
    var foregroundOpacity: Double = 0.8
    var backgroundColour: NSColor = .clear
    var backgroundOpacity: Double = 0.07
    var hasStrike: Bool = false
}

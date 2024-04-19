//
//  MarkdownEditor.swift
//  Banksia
//
//  Created by Dave Coleman on 19/4/2024.
//

import Foundation
import SwiftUI
import Styles

enum MarkdownSyntax: CaseIterable {
    case base
    case h1
    case h2
    case h3
    case bold
    case italic
    case boldItalic
    case inlineCode
    case codeBlock
    
    var regex: String? {
        switch self {
        case .base:
            nil
        case .h1:
            "^#(.*)"
        case .h2:
            "(?m)^##(.*)"
        case .h3:
            "(?m)^###(.*)"
        case .bold:
            "\\*\\*(.*?)\\*\\*"
        case .italic:
            "\\*(?!\\*)(.*?)\\*(?!\\*)"
        case .boldItalic:
            "\\*\\*\\*(.*?)\\*\\*\\*"
        case .inlineCode:
            "`(?!`)(.*?)`"
        case .codeBlock:
            "(```\\n)(.*?)(\\n```)"
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
        case .inlineCode: -1
        case .codeBlock: -4
        default: 1
        }
    }
    
    var syntaxRangeLength: Int {
        switch self {
        case .bold: 4
        case .italic: 2
        case .boldItalic: 2
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
        case .base:
            MarkdownStyleAttributes()
            
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
                fontWeight: .bold,
                foregroundOpacity: 1.0
            )
        case .italic:
            MarkdownStyleAttributes(isItalic: true)
            
        case .boldItalic:
            MarkdownStyleAttributes(
                fontWeight: .bold,
                isItalic: true
            )
        case .inlineCode, .codeBlock:
            MarkdownStyleAttributes(
                fontWeight: .medium,
                isMono: true,
                foregroundColor: .eggplant
            )
            
        }
    } // END content attributes
    
    var syntaxAttributes: MarkdownStyleAttributes {
        switch self {
        case .base:
            MarkdownStyleAttributes(
                foregroundOpacity: 0.3
            )
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
        case .bold, .italic, .boldItalic:
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
    var backgroundOpacity: Double = 0.1
}


class StylableTextEditor: NSTextView {
    
    override var intrinsicContentSize: NSSize {
        guard let layoutManager = self.layoutManager, let container = self.textContainer else {
            return super.intrinsicContentSize
        }
        container.containerSize = NSSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        layoutManager.ensureLayout(for: container)
        
        let rect = layoutManager.usedRect(for: container)
        return NSSize(width: NSView.noIntrinsicMetric, height: rect.height)
    }
    
    
    func setupStyle(for style: MarkdownStyleAttributes) -> [NSAttributedString.Key: Any] {
        
        let bodyDescriptor = NSFontDescriptor.preferredFontDescriptor(forTextStyle: .body)
        
        var contentFont: NSFont? {
            if style.isMono {
                return NSFont.monospacedSystemFont(ofSize: style.fontSize, weight: style.fontWeight)
            } else if style.isItalic {
                return NSFont(descriptor: bodyDescriptor.withSymbolicTraits(.italic), size: style.fontSize)
            } else {
                return NSFont.systemFont(ofSize: style.fontSize, weight: style.fontWeight)
            }
        }
        
        if let font = contentFont {
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font as Any,
                .foregroundColor: style.foregroundColor.withAlphaComponent(style.foregroundOpacity),
                .backgroundColor: style.backgroundColour.withAlphaComponent(style.backgroundOpacity)
            ]
            return attributes
        } else {
            return [:]
        }

    } // END set text style

    
    func applyStyles() {
        
        guard let textStorage = self.textStorage else {
            print("Text storage not available for styling")
            return
        }
        
        let selectedRange = self.selectedRange()
        
        // MARK: - Set initial styles (First!)
        
        //        let bodyFontDescriptor = NSFontDescriptor.preferredFontDescriptor(forTextStyle: .body)
        //
        //        let paragraphStyle = NSMutableParagraphStyle()
        //        paragraphStyle.lineSpacing = 4.5 // example line spacing
        //
        //        let baseAttributes: [NSAttributedString.Key: Any] = [
        //            .font: NSFont.systemFont(ofSize: Styles.fontSize, weight: .regular),
        //            .foregroundColor: defaultForegroundColour,
        //            .paragraphStyle: paragraphStyle
        //        ]
        
        let attributedString = NSMutableAttributedString(string: textStorage.string, attributes: setupStyle(for: MarkdownSyntax.base.contentAttributes))
        
        for syntax in MarkdownSyntax.allCases {
            styleText(
                withRegex: syntax.regex,
                textAttributes: setupStyle(for: syntax.contentAttributes),
                syntaxAttributes: setupStyle(for: syntax.syntaxAttributes),
                contentRange: syntax.contentRange,
                syntaxRangeLocation: syntax.syntaxRangeLocation,
                syntaxRangeLength: syntax.syntaxRangeLength,
                withString: attributedString
            )
        }
        
        self.setSelectedRange(selectedRange)
    }

    func styleText(
        withRegex regexString: String?,
        regexOptions: NSRegularExpression.Options = [],
        textAttributes: [NSAttributedString.Key: Any],
        syntaxAttributes: [NSAttributedString.Key: Any],
        contentRange: Int = 1,
        syntaxRangeLocation: Int = 0,
        syntaxRangeLength: Int = 0,
        withString attributedString: NSMutableAttributedString
    ) {
        guard let textStorage = self.textStorage else {
            print("Text storage not available for styling")
            return
        }
        
        
        let range = NSRange(location: 0, length: attributedString.length)
        
        if let regexString = regexString {
            let regex = try! NSRegularExpression(pattern: regexString, options: regexOptions)
            
            regex.enumerateMatches(
                in: attributedString.string,
                options: [],
                range: range
            ) { match, _, _ in
                
                guard let range = match?.range(at: contentRange) else { return }
                
                let syntaxRange = NSRange(location: range.location + syntaxRangeLocation, length: range.length + syntaxRangeLength)
                
                attributedString.addAttributes(syntaxAttributes, range: syntaxRange)
                attributedString.addAttributes(textAttributes, range: range)
            }
        }
        
        
        textStorage.setAttributedString(attributedString)
    } // END style text
    
    
    
    
    
    override func didChangeText() {
        super.didChangeText()
        applyStyles()
    }
}

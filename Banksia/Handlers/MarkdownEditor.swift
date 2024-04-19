//
//  MarkdownEditor.swift
//  Banksia
//
//  Created by Dave Coleman on 19/4/2024.
//

import Foundation
import SwiftUI
import Styles



enum FontDesign: CaseIterable {
    case system
    case mono
}

enum MarkdownComponent {
    case content
    case syntax
    
}
enum MarkdownSyntax {
    case base
    case h1
    case h2
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
            "^##(.*)"
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
    
//    func component(_ component: MarkdownComponent) {
//        switch component {
//        case .content:
//
//        case .syntax:
//            <#code#>
//        }
//    } // END component

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
}

func setupStyle(for syntax: MarkdownSyntax) {
    
    
}




struct MarkdownStyleAttributes {
    var fontSize: Double = 15
    var fontWeight: NSFont.Weight = .regular
    var fontDesign: FontDesign = .system
    var foregroundColor: NSColor = .textColor
    var foregroundOpacity: Double = 1.0
    var backgroundColour: NSColor = .clear
    
    static let defaultSyntaxStyle = MarkdownStyleAttributes(foregroundOpacity: 0.2)
    
    
    
    static let h1Content =  MarkdownStyleAttributes(fontSize: 28)
    static let h1Syntax =   MarkdownStyleAttributes(fontSize: 28, fontWeight: .medium)
    
    static let h2Content =   MarkdownStyleAttributes(fontSize: 28, fontWeight: .medium)
    static let h2Syntax =   MarkdownStyleAttributes(fontSize: 28, fontWeight: .medium)
}


//enum MarkdownStyle {
//    case content
//    case syntax
//
//
//    var fontSize: Double {
//        switch self {
//        case .base:
//            return Styles.fontSize
//        case .h1:
//            return 28
//        case .bold:
//            return 24
//        case .italic:
//            return Styles.fontSize
//        case .inlineCode:
//            return Styles.fontSizeMono
//        }
//    }
//
//    var fontWeight: NSFont.Weight {
//        switch self {
//        case .base:
//            return .regular
//        case .h1:
//            return .regular
//        case .bold:
//            return .bold
//        case .italic:
//            return .medium
//        case .inlineCode:
//            return .medium
//        }
//    }
//
//} // END markdown syntax



class StylableTextEditor: NSTextView {
    
    let defaultForegroundColour = NSColor.white.withAlphaComponent(0.8)
    
    override var intrinsicContentSize: NSSize {
        guard let layoutManager = self.layoutManager, let container = self.textContainer else {
            return super.intrinsicContentSize
        }
        container.containerSize = NSSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        layoutManager.ensureLayout(for: container)
        
        let rect = layoutManager.usedRect(for: container)
        return NSSize(width: NSView.noIntrinsicMetric, height: rect.height)
    }
    
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
        
        let attributedString = NSMutableAttributedString(string: textStorage.string, attributes: setTextStyle(for: .base))
        
        
    }
    
    
    
    //        let attributedString = NSMutableAttributedString(string: self.textStorage?.string)
    
    
    // MARK: - H1
    
    styleText(
        withRegex: "^#(.*)",
        textAttributes: setTextStyle(
            fontSize: h1FontSize,
            fontweight: .medium
        ),
        syntaxAttributes: setTextStyle(
            fontSize: h1FontSize,
            fontweight: .light,
            foregroundOpacity: 0.2
        ),
        syntaxRangeLocation: -1,
        withString: attributedString
        
    )
    
    // MARK: - H2
    
    
    
    styleText(
        withRegex: "^##(.*)",
        regexOptions: [.anchorsMatchLines],
        textAttributes: [
            .font: NSFont.systemFont(ofSize: h2FontSize, weight: .medium),
            .foregroundColor: defaultForegroundColour
        ],
        syntaxAttributes: setTextStyle(
            fontSize: h1FontSize,
            fontweight: .light,
            foregroundOpacity: 0.2
        ),
        syntaxRangeLocation: -2,
        withString: attributedString
        
    )
    
    
    // MARK: - Bold
    
    styleText(
        withRegex: "\\*\\*(.*?)\\*\\*",
        textAttributes: [
            .font: NSFont.boldSystemFont(ofSize: Styles.fontSize),
            .foregroundColor: defaultForegroundColour,
            
        ],
        syntaxAttributes: [
            .foregroundColor: NSColor.white.withAlphaComponent(0.3)
        ],
        syntaxRangeLocation: -2,
        syntaxRangeLength: 4,
        withString: attributedString
        
    )
    
    
    
    
    // MARK: - Italic
    
    let italicFont = NSFont(descriptor: bodyFontDescriptor.withSymbolicTraits(.italic), size: Styles.fontSize)
    
    styleText(
        withRegex: "\\*(.*?)\\*",
        textAttributes: [
            .font: italicFont as Any,
            .foregroundColor: defaultForegroundColour,
            
            
        ],
        syntaxAttributes: [
            .foregroundColor: NSColor.textColor.withAlphaComponent(0.3)
        ],
        syntaxRangeLocation: -1,
        syntaxRangeLength: 2,
        withString: attributedString
    )
    
    
    // MARK: - Bold Italic
    
    let boldItalicFontDescriptor = NSFont(descriptor: bodyFontDescriptor.withSymbolicTraits([.italic, .bold]), size: Styles.fontSize)
    
    styleText(
        withRegex: "\\*\\*\\*(.*?)\\*\\*\\*",
        textAttributes: [
            .font: boldItalicFontDescriptor as Any,
            .foregroundColor: defaultForegroundColour,
            
            
        ],
        syntaxAttributes: [
            .foregroundColor: NSColor.textColor.withAlphaComponent(0.3)
        ],
        syntaxRangeLocation: -1,
        syntaxRangeLength: 2,
        withString: attributedString
    )
    
    
    
    // MARK: - Inline code
    styleText(
        withRegex: "`(?!`)(.*?)`",
        textAttributes: [
            .foregroundColor: NSColor.eggplant,
            .font: NSFont.monospacedSystemFont(ofSize: Styles.fontSizeMono, weight: .medium),
            
        ],
        syntaxAttributes: [
            .foregroundColor: NSColor.white.withAlphaComponent(0.2),
            .backgroundColor: NSColor.white.withAlphaComponent(0.05),
            .font: NSFont.systemFont(ofSize: Styles.fontSize, weight: .bold)
        ],
        syntaxRangeLocation: -1,
        syntaxRangeLength: 2,
        withString: attributedString
    )
    
    // MARK: - Code block
    styleText(
        withRegex: "(```\\n)(.*?)(\\n```)",
        regexOptions: [.dotMatchesLineSeparators],
        textAttributes: [
            .foregroundColor: NSColor.eggplant,
            .font: NSFont.monospacedSystemFont(ofSize: Styles.fontSizeMono, weight: .medium),
        ],
        syntaxAttributes: [
            .foregroundColor: NSColor.white.withAlphaComponent(0.2),
            .backgroundColor: NSColor.white.withAlphaComponent(0.035),
            .font: NSFont.systemFont(ofSize: Styles.fontSize, weight: .bold)
        ],
        contentRange: 2,
        syntaxRangeLocation: -4,
        syntaxRangeLength: 9,
        withString: attributedString
    )
    
    
    self.setSelectedRange(selectedRange)
    
    
    func styleText(
        withRegex regexString: String,
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
        
        textStorage.setAttributedString(attributedString)
    } // END style text
    
    
    
    
    
    override func didChangeText() {
        super.didChangeText()
        applyStyles()
    }
}

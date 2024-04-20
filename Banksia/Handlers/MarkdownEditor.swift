//
//  MarkdownEditor.swift
//  Banksia
//
//  Created by Dave Coleman on 19/4/2024.
//

import Foundation
import SwiftUI
import Styles


class MarkdownEditor: NSTextView {
    
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
            var attributes: [NSAttributedString.Key: Any] = [
                .font: font as Any,
                .foregroundColor: style.foregroundColor.withAlphaComponent(style.foregroundOpacity),
                .backgroundColor: style.backgroundColour.withAlphaComponent(style.backgroundOpacity),
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .strikethroughColor: NSColor.textColor.withAlphaComponent(0.7)
            ]
            
            if !style.hasStrike {
                attributes.removeValue(forKey: .strikethroughStyle)
            }
            
            return attributes
            
        } else {
            return [:]
        }
        
    } // END set text style
    
    func assessSelectedRange(_ selectedRange: NSRange) {
        
        guard let textStorage = self.textStorage else {
            print("Text storage not available for styling")
            return
        }
        
        let pattern = "\\*\\*(.*?)\\*\\*"
        let documentRange = NSRange(location: 0, length: textStorage.string.count)
        
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            print("There was an issue making the `NSRegularExpression`")
            return
        }
        
        regex.enumerateMatches(
            in: textStorage.string,
            options: [],
            range: documentRange
        ) { match, flags, unsafePointer in
            
            guard let matchedRange = match?.range(at: 0) else { return }
            
            if NSLocationInRange(selectedRange.location, matchedRange) {
                print("Cursor is within a bold pattern")
            }
            
        } // END enumerate matches
        
    } // END assess selecred range
    
    
    func applyStyles() {
        
        guard let textStorage = self.textStorage else {
            print("Text storage not available for styling")
            return
        }
        
        let selectedRange = self.selectedRange()
        
        // MARK: - Set initial styles (First!)
        let attributedString = NSMutableAttributedString(string: textStorage.string, attributes: setupStyle(for: MarkdownSyntax.base.contentAttributes))
        
        for syntax in MarkdownSyntax.allCases {
            styleText(
                withRegex: syntax.regex,
                textAttributes: setupStyle(for: syntax.contentAttributes),
                syntaxAttributes: setupStyle(for: syntax.syntaxAttributes),
                selectedRange: selectedRange,
                contentRange: syntax.contentRange,
                syntaxRangeLocation: syntax.syntaxRangeLocation,
                syntaxRangeLength: syntax.syntaxRangeLength,
                hideSyntax: syntax.hideSyntax,
                withString: attributedString
            )
        }
        
        self.setSelectedRange(selectedRange)
    }
    
    func styleText(
        withRegex regexString: String?,
        textAttributes: [NSAttributedString.Key: Any],
        syntaxAttributes: [NSAttributedString.Key: Any],
        selectedRange: NSRange,
        contentRange: Int,
        syntaxRangeLocation: Int,
        syntaxRangeLength: Int,
        hideSyntax: Bool,
        withString attributedString: NSMutableAttributedString
    ) {
        guard let textStorage = self.textStorage else {
            print("Text storage not available for styling")
            return
        }
        
        let documentRange = NSRange(location: 0, length: attributedString.length)
        
        if let regexString = regexString {
            
            guard let regex = try? NSRegularExpression(pattern: regexString, options: []) else {
                
                print("There was an issue making the `NSRegularExpression`")
                return
            }
            
            regex.enumerateMatches(
                in: attributedString.string,
                options: [],
                range: documentRange
            ) { match, flags, unsafePointer in
                
                guard let matchedRange = match?.range(at: contentRange) else { return }
                
                let syntaxRange = NSRange(location: matchedRange.location + syntaxRangeLocation, length: matchedRange.length + syntaxRangeLength)
                
                attributedString.addAttributes(syntaxAttributes, range: syntaxRange)
                attributedString.addAttributes(textAttributes, range: matchedRange)
                
                
                
            }
        }
        
        textStorage.setAttributedString(attributedString)
    } // END style text
    
    
    
    
    
    override func didChangeText() {
        super.didChangeText()
        applyStyles()
    }
}

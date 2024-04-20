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
        
//        let documentRange = NSRange(location: 0, length: textStorage.string.count)
        //        print("Document word count: \(documentRange.length)")
        
        for syntax in MarkdownSyntax.allCases {
            
            let string = textStorage.string
            
            if let range = Range(selectedRange, in: string) {
                
                let syntaxMatches = string.matches(of: syntax.regex)
                
                for match in syntaxMatches {
                    
                    if match.range.contains(range.lowerBound) {
                        //                        print("Cursor is within \(syntax.name)")
                    } else {
                        //                        print("No reported selection matches for \(syntax.name)")
                    }
                    
                }
            }
            
        } // END loop markdown syntax
    } // END assess selecred range
    
    
    func applyStyles() {
        
        guard let textStorage = self.textStorage else {
            print("Text storage not available for styling")
            return
        }
        
        let selectedRange = self.selectedRange()
        
        // MARK: - Set initial styles (First!)
        let attributedString = NSMutableAttributedString(string: textStorage.string, attributes: [:])
        
        /// Default/base styles
        styleText(
            textAttributes: setupStyle(for: MarkdownStyleAttributes()),
            syntaxAttributes: [:],
            selectedRange: selectedRange,
            withString: attributedString
        )
        
        let syntaxList = MarkdownSyntax.allCases.drop {$0.name == "codeBlock"}
        /// Default/base styles
        
        for syntax in syntaxList {
            styleText(
                withRegex: syntax.regex,
                textAttributes: setupStyle(for: syntax.contentAttributes),
                syntaxAttributes: setupStyle(for: syntax.syntaxAttributes),
                selectedRange: selectedRange,
                syntaxCharacters: syntax.syntaxCharacters,
                syntaxSymmetrical: syntax.syntaxSymmetrical,
                hideSyntax: syntax.hideSyntax,
                withString: attributedString
            )
        }
        
        self.setSelectedRange(selectedRange)
    }
    
    func styleText(
        withRegex regexLiteral: Regex<(Substring, content: Substring)>? = nil,
        textAttributes: [NSAttributedString.Key: Any],
        syntaxAttributes: [NSAttributedString.Key: Any] = [:],
        selectedRange: NSRange,
        syntaxCharacters: Int = 1,
        syntaxSymmetrical: Bool = true,
        hideSyntax: Bool = false,
        withString attributedString: NSMutableAttributedString
    ) {
        guard let textStorage = self.textStorage else {
            print("Text storage not available for styling")
            return
        }
        
        let documentRange = NSRange(location: 0, length: attributedString.length)
        
        if let regexLiteral = regexLiteral {
            
            let string = attributedString.string
            let matches = string.matches(of: regexLiteral)
            
            /// The below did actually worked, where `regexLiteral` was type `Regex<(Substring, content: Substring)>` and value `/\*\*(?<content>.*?)\*\*/`
            //            if let match = string.firstMatch(of: regexLiteral) {
            //                print("Content substring: \(match.content)")
            //            }
            
            //            for match in matches {
            //
            //                let range = NSRange(match.range, in: string)
            //                print("Range location: \(range.location), Range length: \(range.length)")
            //
            //                let contentRange = NSRange(location: range.location + contentRangeLocation, length: range.length + contentRangeLength)
            //                print("Content range location: \(contentRange.location), Content range length: \(contentRange.length)")
            //
            //                let syntaxRange = NSRange(location: range.location + syntaxRangeLocation, length: range.length + syntaxRangeLength)
            //                print("Syntax range location: \(syntaxRange.location), Syntax range length: \(syntaxRange.length)")
            //
            //                attributedString.addAttributes(syntaxAttributes, range: syntaxRange)
            //                attributedString.addAttributes(textAttributes, range: contentRange)
            //            }
            
            for match in matches {
                let range = NSRange(match.range, in: string)
                print("Range location: \(range.location), Range length: \(range.length)")
                
                
                
                let contentRange = NSRange(location: range.location + syntaxCharacters, length: syntaxSymmetrical ? (range.length - syntaxCharacters) - syntaxCharacters : (range.length - syntaxCharacters))
                
                let startSyntaxRange = NSRange(location: range.location, length: syntaxCharacters)
                
                let endSyntaxRange = NSRange(location: range.location + range.length - syntaxCharacters, length: syntaxCharacters)
                
                attributedString.addAttributes(syntaxAttributes, range: startSyntaxRange)
                attributedString.addAttributes(syntaxAttributes, range: endSyntaxRange)
                attributedString.addAttributes(textAttributes, range: contentRange)
                
                print("\n\n")
            }
            
        } else {
            attributedString.addAttributes(textAttributes, range: documentRange)
        }
        
        
        textStorage.setAttributedString(attributedString)
        
    } // END style text
    
    
    
    
    
    override func didChangeText() {
        super.didChangeText()
        applyStyles()
    }
}

//
//  MarkdownEditor.swift
//  Banksia
//
//  Created by Dave Coleman on 19/4/2024.
//

import Foundation
import SwiftUI
import Styles
import Highlightr

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
    
    
    //    func setupStyle(for style: MarkdownStyleAttributes) -> [AttributeContainer] {
    //
    //        let container = AttributeContainer()
    //
    //        attributeContainer.font?.monospaced()
    //
    //        let bodyDescriptor = NSFontDescriptor.preferredFontDescriptor(forTextStyle: .body)
    //
    //        var contentFont: NSFont? {
    //            if style.isMono {
    //                return NSFont.monospacedSystemFont(ofSize: style.fontSize, weight: style.fontWeight)
    //            } else if style.isItalic {
    //                return NSFont(descriptor: bodyDescriptor.withSymbolicTraits(.italic), size: style.fontSize)
    //            } else {
    //                return NSFont.systemFont(ofSize: style.fontSize, weight: style.fontWeight)
    //            }
    //        }
    //
    //
    //        if let font = contentFont {
    //            var attributes: [NSAttributedString.Key: Any] = [
    //                .font: font as Any,
    //                .foregroundColor: style.foregroundColor.withAlphaComponent(style.foregroundOpacity),
    //                .backgroundColor: style.backgroundColour.withAlphaComponent(style.backgroundOpacity),
    //                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
    //                .strikethroughColor: NSColor.textColor.withAlphaComponent(0.7)
    //            ]
    //
    //            if !style.hasStrike {
    //                attributes.removeValue(forKey: .strikethroughStyle)
    //            }
    //
    //            return attributes
    //
    //        } else {
    //            return [:]
    //        }
    
    //    } // END set text style
    
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
                        print("Cursor is within \(syntax.name)")
                    } else {
                        print("No reported selection matches for \(syntax.name)")
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
        
        let globalParagraphStyles = NSMutableParagraphStyle()
        globalParagraphStyles.lineSpacing = 3.5
        globalParagraphStyles.paragraphSpacing = 14
        
        let baseStyles: [NSAttributedString.Key : Any] = [
            .font: NSFont.systemFont(ofSize: Styles.fontSize, weight: .medium),
            .foregroundColor: NSColor.textColor.withAlphaComponent(0.85),
            .paragraphStyle: globalParagraphStyles
        ]
        
        // MARK: - Set initial styles (First!)
        let attributedString = NSMutableAttributedString(string: textStorage.string, attributes: baseStyles)
        
        /// Default/base styles
        //        let documentRange = Range
        
        
        textStorage.setAttributedString(attributedString)
        
        
        let syntaxList = MarkdownSyntax.allCases
        //        let syntaxList = MarkdownSyntax.allCases.filter {$0.name == "codeBlock"}
        for syntax in syntaxList {
            styleText(
                for: syntax,
                withString: attributedString
            )
        }
        
        self.setSelectedRange(selectedRange)
    }
    
    
    
    func styleText(
        for syntax: MarkdownSyntax,
        withString attributedString: NSMutableAttributedString
    ) {
        guard let textStorage = self.textStorage else {
            print("Text storage not available for styling")
            return
        }
        
        let regexLiteral: Regex<(Substring, Substring)> = syntax.regex
        //        let contentAttributes = setupStyle(for: syntax.contentAttributes)
        //        let syntaxAttributes = setupStyle(for: syntax.syntaxAttributes)
        let syntaxCharacters: Int = syntax.syntaxCharacters
        let syntaxSymmetrical: Bool = syntax.syntaxSymmetrical
        //        let hideSyntax: Bool = syntax.hideSyntax
        
        let string = attributedString.string
        let matches = string.matches(of: regexLiteral)
        
        for match in matches {
            let range = NSRange(match.range, in: string)
//            print("Range location: \(range.location), Range length: \(range.length)")
            
            
            
            /// Content range
            let contentLocation = max(0, range.location + syntaxCharacters)
            let contentLength = min(range.length - (syntaxSymmetrical ? 2 : 1) * syntaxCharacters, attributedString.length - contentLocation)
            let contentRange = NSRange(location: contentLocation, length: contentLength)
            
            /// Opening syntax range
            let startSyntaxLocation = range.location
            let startSyntaxLength = min(syntaxCharacters, attributedString.length - startSyntaxLocation)
            let startSyntaxRange = NSRange(location: startSyntaxLocation, length: startSyntaxLength)
            
            /// Closing syntax range
            let endSyntaxLocation = max(0, range.location + range.length - syntaxCharacters)
            let endSyntaxLength = min(syntax == .codeBlock ? syntaxCharacters + 1 : syntaxCharacters, attributedString.length - endSyntaxLocation)
            let endSyntaxRange = NSRange(location: endSyntaxLocation, length: endSyntaxLength)
            
            /// Paragraph range
            let paragraphLocation = max(0, range.location)
            let paragraphLength = min(range.length, attributedString.length)
            let paragraphRange = NSRange(location: paragraphLocation, length: paragraphLength)
            
            /// Apply attributes
            if attributedString.length >= startSyntaxRange.upperBound {
                attributedString.addAttributes(syntax.syntaxAttributes, range: startSyntaxRange)
            }
            
            if attributedString.length >= endSyntaxRange.upperBound {
                attributedString.addAttributes(syntax.syntaxAttributes, range: endSyntaxRange)
            }
            
            if attributedString.length >= contentRange.upperBound {
                
                attributedString.addAttributes(syntax.contentAttributes, range: contentRange)
            }
            
            if attributedString.length >= paragraphRange.upperBound {

                let paragraphStyles = NSMutableParagraphStyle()
                
                switch syntax {
                case .h1:
                    paragraphStyles.lineSpacing = 1
//                    paragraphStyles.headIndent = 26
                    paragraphStyles.paragraphSpacing = 12
                case .h2:
                    paragraphStyles.paragraphSpacing = 10
                case .h3:
                    paragraphStyles.paragraphSpacing = 10
//                case .bold:
//                    <#code#>
//                case .italic:
//                    <#code#>
//                case .boldItalic:
//                    <#code#>
//                case .strikethrough:
//                    <#code#>
//                case .inlineCode:
//                    <#code#>
                case .codeBlock:
                    paragraphStyles.lineSpacing = 4
                    paragraphStyles.paragraphSpacing = 0
                default:
                    paragraphStyles.lineSpacing = 3.5
                }
                
                let paragraphAttributes: [NSMutableAttributedString.Key : Any] = [
                    .paragraphStyle: paragraphStyles
                ]
                
                attributedString.addAttributes(paragraphAttributes, range: paragraphRange)
                
                if syntax == .codeBlock {
                    
                    
                    
                } // end code block check
                
            } // END paragraph styles
            
            
            
                
//                let highlightr = Highlightr()
//                highlightr?.setTheme(to: "atom-one-dark")
//                
//                let codeLanguageRegex = /(?m)^```(swift|python)?\n([\s\S]*?)```/
//                let codeLanguageMatches = string.matches(of: codeLanguageRegex)
//                
//                var language: String = ""
////                
//                for languageMatch in codeLanguageMatches {
//                    language = String(languageMatch.output.1 ?? "plain")
//                }
//
////                let languages: [String] = ["python", "swift", "plain"]
////                let randomLanguage = languages.randomElement()
//                
//                
//                let code: String = String(match.output.1)
//                
////                highlightr?.themeChanged = .some({ theme in
////                    print(theme.codeFont.boundingRectForFont.size.height)
////                })
//                
//
//                let highlightedCode = highlightr?.highlight(code, as: language)
//                
//                
//                //                attributedString.addAttributes(syntaxAttributes, range: startSyntaxRange)
//                
//                
//                
//                if let highlightedCode = highlightedCode {
//                    
//                    attributedString.replaceCharacters(in: contentRange, with: highlightedCode)
//                }
//                
//                
                
                
            
            
            
            print("\n\n")
        }
        
        
        
        textStorage.setAttributedString(attributedString)
        
    } // END style text
    
    
    
    
    
    override func didChangeText() {
        super.didChangeText()
        applyStyles()
    }
}



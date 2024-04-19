//
//  MarkdownEditor.swift
//  Banksia
//
//  Created by Dave Coleman on 19/4/2024.
//

import Foundation
import SwiftUI
import Styles

class StylableTextEditor: NSTextView {
    
    let defaultForegroundColour = NSColor.textColor.withAlphaComponent(0.8)
    
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
        
        
        let selectedRange = self.selectedRange()
        
        

        // MARK: - Bold
        
//        styleText(
//            withRegex: "\\*\\*(.*?)\\*\\*",
//            textAttributes: [
//                .foregroundColor: defaultForegroundColour,
//                .font: NSFont.boldSystemFont(ofSize: Styles.fontSize)
//            ],
//            syntaxAttributes: [
//                .foregroundColor: NSColor.white.withAlphaComponent(0.3)
//            ],
//            contentRange: 2,
//            syntaxRangeLocation: 0,
//            syntaxRangeLength: 2
//        )
        

        
        // MARK: - Italic
//        styleText(
//            withRegex: "\\*(.*?)\\*",
//            textAttributes: [
//                .foregroundColor: defaultForegroundColour,
//
//            ],
//            syntaxAttributes: [
//                .foregroundColor: NSColor.textColor.withAlphaComponent(0.3)
//            ],
//            contentRange: 1,
//            syntaxRangeLocation: -2,
//            syntaxRangeLength: 1
//        )
        
        // MARK: - Inline code
        styleText(
            withRegex: "`.*?`",
            textAttributes: [
                .foregroundColor: NSColor.white.withAlphaComponent(0.7),
                .font: NSFont.monospacedSystemFont(ofSize: Styles.fontSizeMono, weight: .medium),
                .backgroundColor: NSColor.white.withAlphaComponent(0.05)
            ],
            syntaxAttributes: [
                .foregroundColor: NSColor.white.withAlphaComponent(0.3),
                .backgroundColor: NSColor.white.withAlphaComponent(0.05),
                .font: NSFont.systemFont(ofSize: Styles.fontSize, weight: .bold)
            ],
            contentRange: 0,
            syntaxRangeLocation: -2,
            syntaxRangeLength: 1
        )
        
        
//        
//        /// Code block
//        let codeBlockRegex = try! NSRegularExpression(pattern: "(```\\n)(.*?)(\\n```)", options: [.dotMatchesLineSeparators])
//        codeBlockRegex.enumerateMatches(in: attributedString.string, options: [], range: NSRange(location: 0, length: attributedString.length)) { match, _, _ in
//            guard let matchRange = match?.range(at: 2) else { return }
//            attributedString.addAttributes([
//                .foregroundColor: NSColor.systemPurple,
//                .font: NSFont.monospacedSystemFont(ofSize: Styles.fontSizeMono, weight: .medium),
//                .backgroundColor: NSColor.white.withAlphaComponent(0.1)
//            ], range: matchRange)
//        }
//        
        
        self.setSelectedRange(selectedRange)
    } // END apply styles
    
    func styleText(
        withRegex regexString: String,
        regexOptions: NSRegularExpression.Options? = nil,
        textAttributes: [NSAttributedString.Key: Any],
        syntaxAttributes: [NSAttributedString.Key: Any],
        contentRange: Int = 0,
        syntaxRangeLocation: Int = 0,
        syntaxRangeLength: Int = 0
        
    ) {
        
        guard let textStorage = self.textStorage else {
            print("Text storage not available for styling")
            return
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4.5 // example line spacing
        
        let baseAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: Styles.fontSize, weight: .medium),
            .foregroundColor: defaultForegroundColour,
            .paragraphStyle: paragraphStyle
        ]
        
        let attributedString = NSMutableAttributedString(string: textStorage.string, attributes: baseAttributes)
        
        let regex = try! NSRegularExpression(pattern: regexString, options: regexOptions ?? [])
        
        regex.enumerateMatches(
            in: attributedString.string,
            options: [],
            range: NSRange(location: 0, length: attributedString.length)
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

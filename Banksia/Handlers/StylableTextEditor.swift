//
//  StylableTextEditor.swift
//  Banksia
//
//  Created by Dave Coleman on 17/4/2024.
//

import Foundation

//
//  MarkdownEditor.swift
//  Banksia
//
//  Created by Dave Coleman on 11/4/2024.
//

import SwiftUI
import Cocoa

import SwiftUI
import Styles

struct StylableTextEditorRepresentable: NSViewRepresentable {
    @Binding var text: String
    var isEditable: Bool = true
    var maxWidth: Double = 500
    var fontSize: Double = 15
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeNSView(context: Context) -> StylableTextEditor {
        
        /// Nothing in here seems to be causing the jumping to bottom whilst typing. Probably because this doesn't change when the view updates, it just sets it up
        let textView = StylableTextEditor()
        textView.delegate = context.coordinator
        textView.invalidateIntrinsicContentSize()
        textView.string = text
        textView.isEditable = isEditable
        textView.drawsBackground = false
        textView.allowsUndo = true
        textView.setNeedsDisplay(textView.bounds)
        textView.applyStyles()
        
        return textView
    }
    
    func updateNSView(_ textView: StylableTextEditor, context: Context) {
        
        /// This below line was causing the cursor to jump to the bottom every time the text changed
        //        textView.frame = CGRect(origin: .zero, size: context.coordinator.size)
        textView.needsLayout = true
        
        if textView.string != text {
            textView.string = text
            textView.invalidateIntrinsicContentSize()
            
            textView.applyStyles()
        }
        if textView.isEditable != isEditable {
            textView.isEditable = isEditable
        }
    }
    
    class Coordinator: NSObject, NSTextViewDelegate {
        
        var size = CGSize(width: 0, height: 0)
        var parent: StylableTextEditorRepresentable
        
        init(_ parent: StylableTextEditorRepresentable) {
            self.parent = parent
            super.init()
        }
        
        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? StylableTextEditor else { return }
            DispatchQueue.main.async {
                self.parent.text = textView.string
                textView.invalidateIntrinsicContentSize()
            }
        } // Text did change
        
        func updateSize(_ newSize: CGSize) {
            size = newSize
            // You can use this method to update the state in SwiftUI if needed
        }
        
        
    }
}

class StylableTextEditor: NSTextView {
    
//    let fontSize: Double = 15
//    var fontSize: Double
    
//    init(fontSize: Double) {
//        // Create a default text container
//        let container = NSTextContainer(size: CGSize(width: 100, height: 100)) // Adjust the size as needed
//        
//        // Initialize the layout manager
//        let layoutManager = NSLayoutManager()
//        
//        // Initialize the text storage (you've already done this)
//        let textStorage = NSTextStorage(string: "Initial text content")
//        
//        // Add the text container to the layout manager
//        layoutManager.addTextContainer(container)
//        
//        // Set other properties as needed
//        self.fontSize = fontSize
//        
//        // Call the superclass's designated initializer
//        super.init(frame: .zero, textContainer: container)
//        
//    }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
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
        
        print(selectedRange.location)
        print(selectedRange.length)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4.5 // example line spacing
        
        let baseAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: Styles.fontSize, weight: .regular),
            .foregroundColor: NSColor.textColor.withAlphaComponent(0.9),
            .paragraphStyle: paragraphStyle
        ]
        
        let attributedString = NSMutableAttributedString(string: textStorage.string, attributes: baseAttributes)
        
        
        /// Bold
        let boldRegex = try! NSRegularExpression(pattern: "\\*(.*?)\\*", options: [])

        boldRegex.enumerateMatches(
            in: attributedString.string,
            options: [],
            range: NSRange(location: 0, length: attributedString.length)
        ) { match, _, _ in
            guard let boldContent = match?.range(at: 1) else { return }
            
            let boldSyntax = NSRange(location: boldContent.location - 1, length: boldContent.length + 2)

            // Check if the caret position is within the bold content range
            if NSIntersectionRange(selectedRange, boldSyntax).length < 2 {
                // Caret is inside the bold range (show syntax characters in gray)
                attributedString.addAttributes([
                    .foregroundColor: NSColor.gray,
                ], range: boldSyntax)
            } else {
                // Caret is outside the bold range (show syntax characters in blue)
                attributedString.addAttributes([
                    .foregroundColor: NSColor.blue,
                ], range: boldSyntax)
            }

            // Apply special attribute styles to the asterisks
            attributedString.addAttributes([
                .foregroundColor: NSColor.textColor.withAlphaComponent(0.9),
                .font: NSFont.systemFont(ofSize: Styles.fontSize, weight: .bold)
            ], range: boldContent)
        }

        
        /// Inline code
        let inlineCodeRegex = try! NSRegularExpression(pattern: "`.*?`", options: [])
        
        inlineCodeRegex.enumerateMatches(
            in: attributedString.string,
            options: [],
            range: NSRange(location: 0, length: attributedString.length)
        ) { match, flags, unsafePointer in
            
            guard let matchRange = match?.range else { return }
            
            attributedString.addAttributes([
                .foregroundColor: NSColor.systemPurple,
                .font: NSFont.monospacedSystemFont(ofSize: Styles.fontSize, weight: .regular)
            ], range: matchRange)
        }
        
        
        /// Code block
        let codeBlockRegex = try! NSRegularExpression(pattern: "(```\\n)(.*?)(\\n```)", options: [.dotMatchesLineSeparators])
        codeBlockRegex.enumerateMatches(in: attributedString.string, options: [], range: NSRange(location: 0, length: attributedString.length)) { match, _, _ in
            guard let matchRange = match?.range(at: 2) else { return }
            attributedString.addAttributes([
                .foregroundColor: NSColor.systemPurple,
                .font: NSFont.monospacedSystemFont(ofSize: Styles.fontSize, weight: .regular),
                .backgroundColor: NSColor.white.withAlphaComponent(0.1)
            ], range: matchRange)
        }
        
        textStorage.setAttributedString(attributedString)
        self.setSelectedRange(selectedRange)
    }
    
    
    
    
    override func didChangeText() {
        super.didChangeText()
        applyStyles()
    }
}

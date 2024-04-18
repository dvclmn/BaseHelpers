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

struct StylableTextEditorRepresentable: NSViewRepresentable {
    @Binding var text: String
    var isEditable: Bool = true
    var maxWidth: Double = 500
    
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
        
        //        print("Applying styles to text: \(textStorage.string)")
        
        let selectedRange = self.selectedRange()
        
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4.5 // example line spacing
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 15, weight: .medium),
            .foregroundColor: NSColor.textColor,
            .paragraphStyle: paragraphStyle
        ]
        
        let attributedString = NSAttributedString(string: textStorage.string, attributes: attributes)
        textStorage.setAttributedString(attributedString)
        

        let text = NSMutableAttributedString(attributedString: textStorage)
        
        let inlineCode = "`.*?`"
        let codeBlockPattern = "(```\\n)(.*?)(\\n```)"
        
        let regex = try! NSRegularExpression(pattern: codeBlockPattern, options: [.dotMatchesLineSeparators])
        let range = NSRange(location: 0, length: text.length)
        
        regex.enumerateMatches(in: text.string, options: [], range: range) { match, _, _ in
            
            guard let matchRange = match?.range(at: 2) else { return }
            
            text.addAttribute(.foregroundColor, value: NSColor.systemPurple, range: matchRange)
            text.addAttribute(.font, value: NSFont.monospacedSystemFont(ofSize: 12, weight: .regular), range: matchRange)
            text.addAttribute(.backgroundColor, value: NSColor.black.withAlphaComponent(0.1), range: matchRange)
        }
        
        textStorage.setAttributedString(text)
        self.setSelectedRange(selectedRange)
    }
    
    override func didChangeText() {
        super.didChangeText()
        applyStyles()
    }
}

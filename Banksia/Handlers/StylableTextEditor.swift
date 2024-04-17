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
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeNSView(context: Context) -> StylableTextEditor {
        let textView = StylableTextEditor()
        textView.delegate = context.coordinator
        textView.invalidateIntrinsicContentSize()
        textView.string = text
        textView.isEditable = isEditable
        textView.font = .systemFont(ofSize: 15)
        textView.drawsBackground = false
        textView.allowsUndo = true
        return textView
    }
    
    func updateNSView(_ textView: StylableTextEditor, context: Context) {
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
        }
    }
}

class StylableTextEditor: NSTextView {
    override var intrinsicContentSize: NSSize {
        guard let layoutManager = self.layoutManager, let container = self.textContainer else {
            return super.intrinsicContentSize
        }
        layoutManager.ensureLayout(for: container)
        return layoutManager.usedRect(for: container).size
    }
    
    func applyStyles() {
        guard let textStorage = self.textStorage else { return }
        
        let selectedRange = self.selectedRange()
        
        let text = NSMutableAttributedString(attributedString: textStorage)
        
        // Regular expression to find code blocks
        let pattern = "(```\\n)(.*?)(\\n```)"
        let regex = try! NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators])
        let range = NSRange(location: 0, length: text.length)
        
        regex.enumerateMatches(in: text.string, options: [], range: range) { match, _, _ in
            guard let matchRange = match?.range(at: 2) else { return } // match at index 2 is the code content
            text.addAttribute(.foregroundColor, value: NSColor.systemPurple, range: matchRange)
            text.addAttribute(.font, value: NSFont.monospacedSystemFont(ofSize: 12, weight: .regular), range: matchRange)
            text.addAttribute(.backgroundColor, value: NSColor.black.withAlphaComponent(0.1), range: matchRange)
        }
        
        textStorage.setAttributedString(text)
        self.setSelectedRange(selectedRange) // Restore the selected range
    }
    
    override func didChangeText() {
        super.didChangeText()
        applyStyles()
    }
}

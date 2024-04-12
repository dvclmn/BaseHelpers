//
//  MarkdownEditor.swift
//  Banksia
//
//  Created by Dave Coleman on 11/4/2024.
//

import SwiftUI
import Cocoa

// https://github.com/mattDavo/Editor

struct EditorTextViewRepresentable: NSViewRepresentable {
    @Binding var text: String
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeNSView(context: Context) -> SizableTextview {
        let textView = SizableTextview()
        context.coordinator.setupEditor(for: textView)
        textView.delegate = context.coordinator
        textView.invalidateIntrinsicContentSize()
        textView.drawsBackground = false
        textView.allowsUndo = true
        textView.string = text
        
        return textView
    }
    
    func updateNSView(_ textView: SizableTextview, context: Context) {
        if textView.string != text {
            textView.string = text
            textView.invalidateIntrinsicContentSize()
        }
    }
    
    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: EditorTextViewRepresentable
        var editor: Editor?
        var parser: Parser?
        
        
        init(_ parent: EditorTextViewRepresentable) {
            self.parent = parent
            super.init()
            self.parser = Parser(grammars: [exampleGrammar, basicSwiftGrammar, readMeExampleGrammar])
        }
        
        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? SizableTextview else { return }
            
            DispatchQueue.main.async {
                self.parent.text = textView.string
                textView.invalidateIntrinsicContentSize()
            }
        }
        
        func setupEditor(for textView: SizableTextview) {
            
            guard self.editor == nil, let parser = self.parser else { return }
            self.editor = Editor(
                textView: textView,
                parser: parser,
                baseGrammar: exampleGrammar,
                theme: exampleTheme
            )
        }
    }
}

class SizableTextview: EditorTextView {
    override var intrinsicContentSize: NSSize {
        guard let layoutManager = self.layoutManager, let container = self.textContainer else {
            return super.intrinsicContentSize
        }
        layoutManager.ensureLayout(for: container)
        var size = layoutManager.usedRect(for: container).size
        size.width = 400
        return size
    }
    override func didChangeText() {
        super.didChangeText()
        self.invalidateIntrinsicContentSize()
    }
}

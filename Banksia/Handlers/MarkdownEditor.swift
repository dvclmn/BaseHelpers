//
//  MarkdownEditor.swift
//  Banksia
//
//  Created by Dave Coleman on 11/4/2024.
//

import SwiftUI
import EditorCore
import EditorUI

struct EditorTextViewRepresentable: NSViewRepresentable {
    @Binding var text: String
    
    func makeNSView(context: Context) -> NSScrollView {
        
        let scrollView = NSScrollView()
        let textView = EditorTextView()
        
        textView.insertionPointColor = .systemBlue
        textView.string = text
        textView.selectedTextAttributes.removeValue(forKey: .foregroundColor)
        textView.linkTextAttributes?.removeValue(forKey: .foregroundColor)
        
        let parser = Parser(grammars: [exampleGrammar, basicSwiftGrammar, readMeExampleGrammar])
        let editor = Editor(textView: textView, parser: parser, baseGrammar: readMeExampleGrammar, theme: exampleTheme)
        
        editor.subscribe(toToken: "action") { (res) in
            for (str, range) in res {
                print(str, range)
            }
        }
        
        scrollView.hasVerticalScroller = true
        scrollView.documentView = textView
        scrollView.drawsBackground = false // Prevent the scrollView from drawing its background
        textView.autoresizingMask = [.width, .height]
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = false
        textView.minSize = NSSize(width: 0, height: scrollView.bounds.height)
        textView.maxSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        textView.drawsBackground = false
        
        return scrollView
    }
    
    func updateNSView(_ nsView: NSScrollView, context: Context) {
        guard let textView = nsView.documentView as? EditorTextView else { return }
        
        if textView.string != text {
            textView.string = text
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: EditorTextViewRepresentable
        weak var textView: EditorTextView?
        
        init(_ parent: EditorTextViewRepresentable) {
            self.parent = parent
        }
        
        func textDidChange(_ notification: Notification) {
            if let textView = notification.object as? EditorTextView {
                parent.text = textView.string
            }
        }
    }
}

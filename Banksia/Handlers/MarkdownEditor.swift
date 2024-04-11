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
    
    // This function creates the NSView that your representable wraps.
    func makeNSView(context: Context) -> EditorTextView {
        let textView = EditorTextView()
        
        // Perform initial setup based on your viewDidLoad configuration.
        textView.insertionPointColor = .systemBlue
        textView.string = text
        textView.selectedTextAttributes.removeValue(forKey: .foregroundColor)
        textView.linkTextAttributes?.removeValue(forKey: .foregroundColor)
        
        // Initialize your Parser and Editor
        let parser = Parser(grammars: [exampleGrammar, basicSwiftGrammar, readMeExampleGrammar])
        parser.shouldDebug = false
        let editor = Editor(textView: textView, parser: parser, baseGrammar: readMeExampleGrammar, theme: exampleTheme)
        
        // Subscribe to tokens or perform additional editor setup as needed.
        editor.subscribe(toToken: "action") { (res) in
            for (str, range) in res {
                print(str, range)
            }
        }
        
        return textView
    }
    
    func updateNSView(_ nsView: EditorTextView, context: Context) {
        // Update the text if it has changed outside the NSTextView
        if nsView.string != text {
            nsView.string = text
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
            // Update the binding when the text changes
            if let textView = notification.object as? EditorTextView {
                parent.text = textView.string
            }
        }
    }
}

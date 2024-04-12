//
//  MarkdownEditor.swift
//  Banksia
//
//  Created by Dave Coleman on 11/4/2024.
//

import SwiftUI


struct EditorTextViewRepresentable: NSViewRepresentable {
    @Binding var text: String
    
    func makeNSView(context: Context) -> SizingEditorTextView {
        print("makeNSView")
        let textView = SizingEditorTextView()
        context.coordinator.setupEditor(for: textView)
        textView.string = text
        return textView
    }

    func updateNSView(_ nsView: SizingEditorTextView, context: Context) {
        print("updateNSView")
        if nsView.string != text {
            
            print("The text changed: \(nsView.string)")
            
            nsView.string = text
        }
        // Any additional updates based on state changes
    }

    // This will hold the editor-related logic previously in the ViewController
    class Coordinator: NSObject {
        var editor: Editor?
        var parser: Parser?
        
        // You can initialize your parser, editor, and other logic here
        init(text: String) {
            print("Initialised `class Coordinator: NSObject`")

            let parser = Parser(grammars: [exampleGrammar, basicSwiftGrammar])
            self.parser = parser
        }
        
        // Function to create the editor once we have the textView
        func setupEditor(for textView: EditorTextView) {
            print("Let's set up the editor")
            editor = Editor(textView: textView, parser: parser!, baseGrammar: exampleGrammar, theme: exampleTheme)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: self.text)
    }


}

class SizingEditorTextView: EditorTextView {
    override var intrinsicContentSize: NSSize {
        guard let layoutManager = self.layoutManager, let container = self.textContainer else {
            return super.intrinsicContentSize
        }
        layoutManager.ensureLayout(for: container)
        return layoutManager.usedRect(for: container).size
    }
    
    // Override this method to invalidate intrinsic content size as needed
    override func didChangeText() {
        super.didChangeText()
        self.invalidateIntrinsicContentSize()
    }
}

//
//
//struct EditorTextViewRepresentable: NSViewRepresentable {
//    @Binding var text: String
//    
//    func makeNSView(context: Context) -> EditorTextView {
//        print("Created the NSView `EditorTextViewRepresentable`")
//        
//        
//        let textView = EditorTextView()
//        
//        textView.insertionPointColor = .systemBlue
//        textView.selectedTextAttributes.removeValue(forKey: .foregroundColor)
//        textView.string = ""
//        
//        textView.delegate = context.coordinator
//        
//        let parser = Parser(grammars: [exampleGrammar, basicSwiftGrammar])
//        parser.shouldDebug = false
//        let editor = Editor(textView: textView, parser: parser, baseGrammar: exampleGrammar, theme: exampleTheme)
//        
//        
//        
////        textView.autoresizingMask = [.width, .height]
////        textView.isVerticallyResizable = true
////        textView.isHorizontallyResizable = false
////        textView.minSize = NSSize(width: 0, height: scrollView.bounds.height)
////        textView.maxSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
////        textView.drawsBackground = false
//        
//        editor.subscribe(toToken: "action") { (res) in
//            for (str, range) in res {
//                print(str, range)
//            }
//        }
//        
//        return textView
//    }
//    
//    func updateNSView(_ nsView: EditorTextView, context: Context) {
//        
//        print("Entered the `updateNSView` function")
//
//        
//        if nsView.string != text {
//            print("The `Editor` text string has changed, need to update view. '\(nsView.string)'")
//            nsView.string = text
//        }
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//    
//    class Coordinator: NSObject, NSTextViewDelegate {
//        var parent: EditorTextViewRepresentable
//        weak var textView: EditorTextView?
//        
//        init(_ parent: EditorTextViewRepresentable) {
//            self.parent = parent
//        }
//        
//        func textDidChange(_ notification: Notification) {
//            print("Let's see if the text changed")
//            if let textView = notification.object as? EditorTextView {
//                
//                print("`textView`: \(textView)")
//                if parent.text != textView.string {
//                    parent.text = textView.string
//                    print("The text has updated, so the `EditorTextViewRepresentable` text property is now \(parent.text)")
//                }
//            }
//        }
//        
//        
//        
//    }
//}

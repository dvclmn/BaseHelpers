//
//  MarkdownEditor.swift
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
import Styles

struct EditorRepresentable: NSViewRepresentable {
    @Binding var text: String
    var isEditable: Bool = true
    var maxWidth: Double = 500
    var fontSize: Double = 15
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeNSView(context: Context) -> MarkdownEditor {
        
        /// Nothing in here seems to be causing the jumping to bottom whilst typing. Probably because this doesn't change when the view updates, it just sets it up
        let textView = MarkdownEditor()
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
    
    func updateNSView(_ textView: MarkdownEditor, context: Context) {
        
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
        var parent: EditorRepresentable
        
        init(_ parent: EditorRepresentable) {
            self.parent = parent
            super.init()
        }
        
        /// This function actually does not handle any refreshing of the text styles. It just ensures the layout gets redrawn and the text updates, on text edit
        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? MarkdownEditor else { return }
            DispatchQueue.main.async {
                self.parent.text = textView.string
                textView.invalidateIntrinsicContentSize()
            }
        } // END Text did change
        
        func textViewDidChangeSelection(_ notification: Notification) {
            guard let textView = notification.object as? MarkdownEditor else { return }
            
            DispatchQueue.main.async {
                let selectedRange = textView.selectedRange
                textView.assessSelectedRange(selectedRange)

//                print("Selected Range:\nLocation: \(selectedRange.location)\nLength: \(selectedRange.length)\n\n")
            }
            
        } // END changed selection

        
        func updateSize(_ newSize: CGSize) {
            size = newSize
            // You can use this method to update the state in SwiftUI if needed
        }
        
    } // END coordinator
} // END NSViewRepresentable


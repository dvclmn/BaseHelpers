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


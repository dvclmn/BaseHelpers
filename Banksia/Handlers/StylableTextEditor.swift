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

struct StylableTextEditor: NSViewRepresentable {
    @Binding var text: String
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeNSView(context: Context) -> SizableTextEditor {
        let textView = SizableTextEditor()
//        context.coordinator.setupEditor(for: textView)
        textView.delegate = context.coordinator
        textView.invalidateIntrinsicContentSize()
        textView.drawsBackground = false
        textView.allowsUndo = true
        textView.string = text
        textView.font = .systemFont(ofSize: 15)
        
        return textView
    }
    
    func updateNSView(_ textView: SizableTextEditor, context: Context) {
        if textView.string != text {
            textView.string = text
            textView.invalidateIntrinsicContentSize()
        }
    }
    
    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: StylableTextEditor
        
        init(_ parent: StylableTextEditor) {
            self.parent = parent
            super.init()
            
        }
        
        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? SizableTextEditor else { return }
            
            DispatchQueue.main.async {
                self.parent.text = textView.string
                textView.invalidateIntrinsicContentSize()
            }
        }
        

    }
}

class SizableTextEditor: NSTextView {
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

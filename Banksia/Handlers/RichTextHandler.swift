//
//  RichTextHandler.swift
//  Banksia
//
//  Created by Dave Coleman on 13/11/2023.
//

import SwiftUI
import AppKit

struct RichTextView: NSViewRepresentable {
    @Binding var text: String

    func makeNSView(context: Context) -> NSTextView {
        let textView = NSTextView()
        textView.delegate = context.coordinator
        return textView
    }

    func updateNSView(_ nsView: NSTextView, context: Context) {
        nsView.string = text
        applyStyles(to: nsView)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: RichTextView

        init(_ parent: RichTextView) {
            self.parent = parent
        }

        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            self.parent.text = textView.string
            parent.applyStyles(to: textView)
        }
    }

    private func applyStyles(to textView: NSTextView) {
        let attributedString = NSMutableAttributedString(string: textView.string)
        // Example styling rule: turn text red if it contains "red"
        if textView.string.contains("red") {
            attributedString.addAttribute(.foregroundColor, value: NSColor.red, range: NSRange(location: 0, length: attributedString.length))
        }
        textView.textStorage?.setAttributedString(attributedString)
    }
}

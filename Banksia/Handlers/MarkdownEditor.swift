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
        let parser = Parser(grammars: [EditorStyles.readMeExampleGrammar])
        parser.shouldDebug = false
        let editor = Editor(textView: textView, parser: parser, baseGrammar: EditorStyles.readMeExampleGrammar, theme: EditorStyles.readMeExampleTheme)
        
        // Subscribe to tokens or perform additional editor setup as needed.
        editor.subscribe(toToken: "action") { (res) in
            for (str, range) in res {
                print(str, range)
            }
        }
        
        // Store 'editor' and 'parser' if needed, for example in the textView's properties if they are extended to hold references.
        
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


struct EditorStyles {
    static let readMeExampleGrammar = Grammar(
        scopeName: "source.example",
        fileTypes: [],
        patterns: [
            MatchRule(name: "keyword.special.class", match: "\\bclass\\b"),
            MatchRule(name: "keyword.special.let", match: "\\blet\\b"),
            MatchRule(name: "keyword.special.var", match: "\\bvar\\b"),
            BeginEndRule(
                name: "string.quoted.double",
                begin: "\"",
                end: "\"",
                patterns: [
                    MatchRule(name: "source.example", match: #"\\\(.*\)"#, captures: [
                        Capture(patterns: [IncludeGrammarPattern(scopeName: "source.example")])
                    ])
                ]
            ),
            BeginEndRule(name: "comment.line.double-slash", begin: "//", end: "\\n", patterns: [IncludeRulePattern(include: "todo")]),
            BeginEndRule(name: "comment.block", begin: "/\\*", end: "\\*/", patterns: [IncludeRulePattern(include: "todo")])
        ],
        repository: Repository(patterns: [
            "todo": MatchRule(name: "comment.keyword.todo", match: "TODO")
        ])
    )

    

    static let readMeExampleTheme = Theme(name: "basic", settings: [
        ThemeSetting(scope: "comment", parentScopes: [], attributes: [
            ColorThemeAttribute(color: .systemGreen)
        ]),
        ThemeSetting(scope: "keyword", parentScopes: [], attributes: [
            ColorThemeAttribute(color: .systemBlue)
        ]),
        ThemeSetting(scope: "string", parentScopes: [], attributes: [
            ColorThemeAttribute(color: .systemRed)
        ]),
        ThemeSetting(scope: "source", parentScopes: [], attributes: [
            ColorThemeAttribute(color: .textColor),
            FontThemeAttribute(font: .monospacedSystemFont(ofSize: 18, weight: .medium)),
            TailIndentThemeAttribute(value: -30)
        ]),
        ThemeSetting(scope: "comment.keyword", parentScopes: [], attributes: [
            ColorThemeAttribute(color: .systemTeal)
        ])
    ])
}

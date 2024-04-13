//
//  EditorTextView.swift
//  
//
//  Created by Matthew Davidson on 5/12/19.
//

import Foundation


// MARK: - iOS
#if os(iOS)
import UIKit

public class EditorTextView: UITextView {
    
    // MARK: - Attributes
    private var _parser: Parser = Parser(grammars: [.default])
    private var _grammar: Grammar = .default
    private var _theme: EditorTheme = .default
    
    public var grammar: Grammar {
        return _grammar
    }
    
    public var theme: EditorTheme {
        return _theme
    }
    
    public var parser: Parser {
        return _parser
    }
    
    /// Boolean value to determine whether tabs should be instead indented with spaces. The number of spaces is determined by `tabWidth`.
    public var indentUsingSpaces = true
    
    /// If `indentUsingSpaces` is `true` it defines the number of spaces that should be inserted for a tab. If `indentUsingSpaces` is `false` this value will not be used and controlling the width of tabs should be done by setting the `tabStops` and `defaultTabInterval` values of the `NSParagraphStyle` NSAttributedString attribute.
    public var tabWidth = 4
    
    /// Boolean value to determine whether the indentation pattern of the current line should be followed on the insertion of a new line.
    public var autoIndent = true
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("\(#function) is not supported")
    }
    
    public static func create(frame: CGRect) -> EditorTextView {
        // Create text storage
        let textStorage = EditorTextStorage(parser: Parser(grammars: []), baseGrammar: .default, theme: .default)
        
        // Create layout manager
        let layoutManager = EditorLayoutManager()

        // Create container
        let containerSize = CGSize(width: frame.width,
                                 height: .greatestFiniteMagnitude)
        let container = NSTextContainer(size: containerSize)
        container.widthTracksTextView = true
        layoutManager.addTextContainer(container)
        textStorage.addLayoutManager(layoutManager)

        // Create text view
        return EditorTextView(frame: frame, textContainer: container)
    }
    
    func boundingRect(forCharacterRange range: NSRange) -> CGRect? {
        // Convert the range for glyphs.
        var glyphRange = NSRange()
        layoutManager.characterRange(forGlyphRange: range, actualGlyphRange: &glyphRange)

        return layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
    }
}

// MARK: - macOS
#elseif os(macOS)
import Cocoa
import AppKit

public class EditorTextView: NSTextView {
    
    // MARK: - Attributes
    
    private var _layoutManager: NSLayoutManager?
    
    public override var layoutManager: NSLayoutManager? {
        get {
            if let m = _layoutManager {
                return m
            }
            else {
                _layoutManager = EditorLayoutManager()
                _layoutManager?.addTextContainer(textContainer!)
                textStorage?.addLayoutManager(_layoutManager!)
                return _layoutManager
            }
        }
        set(layoutManager) {
            _layoutManager = layoutManager
        }
    }
    
    private var _parser: Parser = Parser(grammars: [.default])
    private var _grammar: Grammar = .default
    private var _theme: EditorTheme = .default
    
    public var grammar: Grammar {
        return _grammar
    }
    
    public var theme: EditorTheme {
        return _theme
    }
    
    public var parser: Parser {
        return _parser
    }
    
    /// Holds the attached line number gutter.
    private var lineNumberGutter: LineNumberGutter?

    /// Holds the text color for the gutter.
    public var gutterForegroundColor: NSColor = .textColor {
        didSet {
            if let gutter = self.lineNumberGutter {
                gutter.foregroundColor = gutterForegroundColor
            }
        }
    }

    /// Holds the background color for the gutter.
    public var gutterBackgroundColor: NSColor = .textBackgroundColor {
        didSet {
            if let gutter = self.lineNumberGutter {
                gutter.backgroundColor = gutterBackgroundColor
            }
        }
    }
    
    /// Holds the text color for the current line in the gutter.
    public var gutterCurrentLineForegroundColor: NSColor = .textColor {
        didSet {
            if let gutter = self.lineNumberGutter {
                gutter.currentLineForegroundColor = gutterCurrentLineForegroundColor
            }
        }
    }
    
    /// Holds the background color for the gutter.
    public var gutterWidth: CGFloat = 40 {
        didSet {
            if let gutter = self.lineNumberGutter {
                gutter.ruleThickness = gutterWidth
            }
        }
    }
    
    /// Boolean value to determine whether tabs should be instead indented with spaces. The number of spaces is determined by `tabWidth`.
    public var indentUsingSpaces = true
    
    /// If `indentUsingSpaces` is `true` it defines the number of spaces that should be inserted for a tab. If `indentUsingSpaces` is `false` this value will not be used and controlling the width of tabs should be done by setting the `tabStops` and `defaultTabInterval` values of the `NSParagraphStyle` NSAttributedString attribute.
    public var tabWidth = 4
    
    /// Boolean value to determine whether the indentation pattern of the current line should be followed on the insertion of a new line.
    public var autoIndent = true
    
    
    // MARK: - Constructors
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        commonInit()
    }
    
    public override init(frame frameRect: NSRect, textContainer container: NSTextContainer?) {
        super.init(frame: frameRect, textContainer: container)
        
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    private func commonInit() {
        // Insert NSLayoutManager subclass
        let manager = EditorLayoutManager()
        textContainer?.replaceLayoutManager(manager)
        layoutManager = manager
        
        // Insert NSTextStorage subclass
        let storage = EditorTextStorage(parser: parser, baseGrammar: grammar, theme: theme)
        storage.append(attributedString())
        layoutManager?.replaceTextStorage(storage)
        
        isRichText = false
        isAutomaticQuoteSubstitutionEnabled = false
        enabledTextCheckingTypes = 0
        allowsUndo = true
        
        addLineNumberObservers()
    }
    
    /// Add observers to redraw the line number gutter, when necessary.
    internal func addLineNumberObservers() {
        self.postsFrameChangedNotifications = true

        NotificationCenter.default.addObserver(self, selector: #selector(drawGutter), name: NSView.frameDidChangeNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(drawGutter), name: NSText.didChangeNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(drawGutter), name: NSTextView.didChangeSelectionNotification, object: self)
    }
    
    public func replace(lineNumberGutter: LineNumberGutter) {
        // Get the enclosing scroll view
        guard let scrollView = self.enclosingScrollView else {
          fatalError("Unwrapping the text views scroll view failed!")
        }
        self.gutterBackgroundColor = lineNumberGutter.backgroundColor
        self.gutterForegroundColor = lineNumberGutter.foregroundColor
        self.gutterCurrentLineForegroundColor = lineNumberGutter.currentLineForegroundColor
        self.lineNumberGutter = lineNumberGutter

        scrollView.verticalRulerView  = self.lineNumberGutter
        scrollView.hasVerticalRuler   = true
        scrollView.rulersVisible      = true
    }
    
    @objc internal func drawGutter() {
        if let lineNumberGutter = self.lineNumberGutter {
            lineNumberGutter.needsDisplay = true
        }
    }
    
    func boundingRect(forCharacterRange range: NSRange) -> CGRect? {
        guard let layoutManager = layoutManager else { return nil }
        guard let textContainer = textContainer else { return nil }
        
        // Convert the range for glyphs.
        var glyphRange = NSRange()
        layoutManager.characterRange(forGlyphRange: range, actualGlyphRange: &glyphRange)

        return layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
    }
    
    // Courtesy of: https://christiantietze.de/posts/2017/08/nstextview-fat-caret/
    public var caretSize: CGFloat = 4
    open override func drawInsertionPoint(in rect: NSRect, color: NSColor, turnedOn flag: Bool) {
        var rect = rect
        rect.size.width = caretSize
        super.drawInsertionPoint(in: rect, color: color, turnedOn: flag)
    }

    open override func setNeedsDisplay(_ rect: NSRect, avoidAdditionalLayout flag: Bool) {
        var rect = rect
        rect.size.width += caretSize - 1
        super.setNeedsDisplay(rect, avoidAdditionalLayout: flag)
    }
    
    public override func insertTab(_ sender: Any?) {
        let range = selectedRange()
        if indentUsingSpaces && tabWidth > 0, let storage = textStorage as? EditorTextStorage, range.location != NSNotFound {
            // Get location into the line
            let lineLoc = storage.getLocationOnLine(range.location)
            // Get spaces that make up the rest of the tab
            let width = tabWidth - lineLoc%tabWidth
            
            storage.replaceCharacters(in: range, with: String(repeating: " ", count: width))
            didChangeText()
        }
        else {
            insertText("\t", replacementRange: selectedRange())
        }
    }
    
    public override func insertNewline(_ sender: Any?) {
        let range = selectedRange()
        if autoIndent, let storage = textStorage as? EditorTextStorage, range.location != NSNotFound {
            let lineNo = storage.getLocationLine(range.location)
            let line = storage.getLine(lineNo) as NSString
            
            var spaces = 0
            var loc = 0
            while loc < line.length - 1 && line.substring(with: NSRange(location: loc, length: 1)) == " " {
                spaces += 1
                loc += 1
            }
            
            storage.replaceCharacters(in: range, with: "\n\(String(repeating: " ", count: spaces))")
            didChangeText()
        }
        else {
            super.insertNewline(sender)
        }
    }
}

#endif

// MARK: - Common
extension EditorTextView {
    internal func replace(parser: Parser, baseGrammar: Grammar, theme: EditorTheme) {
        _parser = parser
        _grammar = baseGrammar
        _theme = theme
        guard let storage = textStorage as? EditorTextStorage else {
            print("Cannot set grammar and them on text storage because it is not of type EditorTextStorage")
            return
        }
        storage.replace(parser: parser, baseGrammar: baseGrammar, theme: theme)
    }
}

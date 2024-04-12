//
//  ItalicThemeAttribute.swift
//  
//
//  Created by Matthew Davidson on 5/12/19.
//

import Foundation
import EditorCore

#if os(iOS)
import UIKit

public class ItalicThemeAttribute: TokenThemeAttribute {
    public var key: String = "italic"
    
    public init() {}
    
    public func apply(to attrStr: NSMutableAttributedString, withRange range: NSRange) {
        let font = attrStr.attributes(at: range.location, effectiveRange: nil)[.font] as? UIFont ?? UIFont()
        
        if let newDescriptor = font.fontDescriptor.withSymbolicTraits(font.fontDescriptor.symbolicTraits.union(.traitItalic)) {
            let newFont = UIFont(descriptor: newDescriptor, size: font.pointSize)
            attrStr.addAttribute(.font, value: newFont, range: range)
        }
        else {
            print("Warning: Failed to add italic font trait to token '\(attrStr.string)' with range: '\(range)'")
        }
    }
}

#elseif os(macOS)
import Cocoa

public class ItalicThemeAttribute: TokenThemeAttribute {
    public var key: String = "italic"
    
    public init() {}
    
    public func apply(to attrStr: NSMutableAttributedString, withRange range: NSRange) {
        let font = attrStr.attributes(at: range.location, effectiveRange: nil)[.font] as? NSFont ?? NSFont()
        let newFont = NSFontManager.shared.convert(font, toHaveTrait: .italicFontMask)
        attrStr.addAttribute(.font, value: newFont, range: range)
    }
    
}

#endif

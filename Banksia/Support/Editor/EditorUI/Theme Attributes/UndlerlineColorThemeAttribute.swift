//
//  UnderlineColorThemeAttribute.swift
//  
//
//  Created by Matthew Davidson on 23/12/19.
//

import Foundation


#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
import AppKit
#endif

public class UnderlineThemeAttribute: TokenThemeAttribute {
    
    public let key = "underline-color"
    public let color: EditorColor
    public let style: NSUnderlineStyle
    
    public init(color: EditorColor, style: NSUnderlineStyle = .single) {
        self.color = color
        self.style = style
    }
    
    public func apply(to attrStr: NSMutableAttributedString, withRange range: NSRange) {
        attrStr.addAttribute(.underlineColor, value: color, range: range)
        attrStr.addAttribute(.underlineStyle, value: style.rawValue, range: range)
    }
}

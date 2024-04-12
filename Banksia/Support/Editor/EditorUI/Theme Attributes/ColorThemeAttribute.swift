//
//  ColorThemeAttribute.swift
//  
//
//  Created by Matthew Davidson on 4/12/19.
//

import Foundation


public class ColorThemeAttribute: TokenThemeAttribute {
    
    public let key = "color"
    public let color: EditorColor
    
    public init(color: EditorColor) {
        self.color = color
    }
    
    public func apply(to attrStr: NSMutableAttributedString, withRange range: NSRange) {
        attrStr.addAttribute(.foregroundColor, value: color, range: range)
    }
}

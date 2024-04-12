//
//  TextAlignmentThemeAttribute.swift
//  
//
//  Created by Matthew Davidson on 16/12/19.
//

import Foundation

#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
import AppKit
#endif

public class TextAlignmentThemeAttribute: LineThemeAttribute {
    
    public let key = "first-line-head-indent"
    public let value: NSTextAlignment
    
    public init(value: NSTextAlignment = .natural) {
        self.value = value
    }
    
    public func apply(to style: EditorMutableParagraphStyle) {
        style.alignment = value
    }
}

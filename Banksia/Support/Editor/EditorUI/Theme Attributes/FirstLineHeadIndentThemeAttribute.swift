//
//  FirstLineHeadIndentThemeAttribute.swift
//  
//
//  Created by Matthew Davidson on 16/12/19.
//

import Foundation

#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif

public class FirstLineHeadIndentThemeAttribute: LineThemeAttribute {
    
    public let key = "first-line-head-indent"
    public let value: CGFloat
    
    public init(value: CGFloat = 0) {
        self.value = value
    }
    
    public func apply(to style: EditorMutableParagraphStyle) {
        style.firstLineHeadIndent = value
    }
}

//
//  LineHeightThemeAttribute.swift
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

public class LineHeightThemeAttribute: LineThemeAttribute {
    
    public let key = "line-height"
    public let min: CGFloat
    public let max: CGFloat
    
    public init(min: CGFloat = 0, max: CGFloat = 0) {
        self.min = min
        self.max = max
    }
    
    public func apply(to style: EditorMutableParagraphStyle) {
        style.minimumLineHeight = min
        style.maximumLineHeight = max
    }
}

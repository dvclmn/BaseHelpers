//
//  NSAttributedString.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 6/7/2025.
//

#if canImport(AppKit)
import AppKit

public extension NSMutableAttributedString {
  
  @MainActor func setAttributeSet(
    _ attributeSet: AttributeSet,
    range: NSRange,
    with typingAttributes: Attributes? = nil
  ) {
    
    if let typingAttributes = typingAttributes {
      setAttributes(attributeSet.attributes, range: range)
      addAttributes(typingAttributes, range: range)
    } else {
      setAttributes(attributeSet.attributes, range: range)
    }
  }
}

#endif

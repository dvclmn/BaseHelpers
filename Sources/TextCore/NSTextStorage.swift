//
//  NSTextStorage.swift
//  TextCore
//
//  Created by Dave Coleman on 11/10/2024.
//

//import AppKit
//
//public extension NSTextStorage {
//  
//  var nsString: NSString {
//    let result = self.string as NSString
//    return result
//  }
//  
//  var documentLength: Int {
//    self.nsString.length
//  }
//  
//  var safeSelectedRange: NSRange {
//    return selectedRange.clamped(to: documentLength)
//  }
//  
//  var safeCurrentParagraphRange: NSRange {
//    let paragraphRange = nsString.paragraphRange(for: safeSelectedRange)
//    return paragraphRange.clamped(to: documentLength)
//  }
//  
//  func getSafeRange(for range: NSRange) -> NSRange {
//    return range.clamped(to: documentLength)
//  }
//}

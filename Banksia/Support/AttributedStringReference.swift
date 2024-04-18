////
////  AttributedStringReference.swift
////  Banksia
////
////  Created by Dave Coleman on 18/4/2024.
////
//
//import Foundation
//
//#if os(iOS)
//import UIKit
//public typealias ParagraphStyle = NSParagraphStyle
//public typealias MutableParagraphStyle = NSMutableParagraphStyle
//
//#elseif os(macOS)
//import Cocoa
//public typealias ParagraphStyle = NSParagraphStyle
//public typealias MutableParagraphStyle = NSMutableParagraphStyle
//
//#endif
//
//
//private static func applyThemeAttributes(_ attributes: [ThemeAttribute], toStr attributedString: NSMutableAttributedString, withStyle style: MutableParagraphStyle, andRange range: NSRange) {
//    for attr in attributes {
//        if let lineAttr = attr as? LineThemeAttribute {
//            lineAttr.apply(to: style)
//        }
//        else if let tokenAttr = attr as? TokenThemeAttribute {
//            tokenAttr.apply(to: attributedString, withRange: range)
//        }
//        else {
//            print("Warning: ThemeAttribute with key \(attr.key) does not conform to either LineThemeAttribute or TokenThemeAttribtue so it will not be applied.")
//        }
//    }
//}
//
//
//public func applyTheme(
//    _ attributedString: NSMutableAttributedString,
//    at loc: Int,
//    inSelectionScope: Bool = false,
//    applyBaseAttributes: Bool = true
//) {
//    
//    // If we are applying the base attributes we will reset the attributes of the attributed string. Otherwise, we will leave them and create a mutable copy of the paragraph style.
//    var style = MutableParagraphStyle()
//    if applyBaseAttributes {
//        attributedString.setAttributes(nil, range: NSRange(location: loc, length: length))
//    }
//    else if let currStyle = (attributedString.attribute(.paragraphStyle, at: loc, effectiveRange: nil) as? ParagraphStyle)?.mutableCopy() as? MutableParagraphStyle {
//        style = currStyle
//    }
//    
//    for token in tokens {
//        for scope in token.scopes {
//            if applyBaseAttributes {
//                TokenizedLine.applyThemeAttributes(
//                    scope.attributes,
//                    toStr: attributedString,
//                    withStyle: style,
//                    andRange: NSRange(location: loc + token.range.location, length: token.range.length))
//            }
//            if inSelectionScope {
//                TokenizedLine.applyThemeAttributes(
//                    scope.inSelectionAttributes,
//                    toStr: attributedString,
//                    withStyle: style,
//                    andRange: NSRange(location: loc + token.range.location, length: token.range.length))
//            }
//            else {
//                TokenizedLine.applyThemeAttributes(
//                    scope.outSelectionAttributes,
//                    toStr: attributedString,
//                    withStyle: style,
//                    andRange: NSRange(location: loc + token.range.location, length: token.range.length))
//            }
//        }
//    }
//    
//    attributedString.addAttribute(.paragraphStyle, value: style, range: NSRange(location: loc, length: length))
//}
//
//public class BoldThemeAttribute: TokenThemeAttribute {
//    public func apply(to attrStr: NSMutableAttributedString, withRange range: NSRange) {
//        let font = attrStr.attributes(at: range.location, effectiveRange: nil)[.font] as? NSFont ?? NSFont()
//        
//        let newFont = NSFontManager.shared.convert(font, toHaveTrait: .boldFontMask)
//        attrStr.addAttribute(.font, value: newFont, range: range)
//    }
//}
//
//public class ColorThemeAttribute: TokenThemeAttribute {
//    public func apply(to attrStr: NSMutableAttributedString, withRange range: NSRange) {
//        attrStr.addAttribute(.foregroundColor, value: color, range: range)
//    }
//}
//
//
//
//public class EditorTextStorage: NSTextStorage {
//    
//    override public func replaceCharacters(in range: NSRange, with str: String) {
//        beginEditing()
//        
//        // First update the storage
//        storage.replaceCharacters(in: range, with:str)
//        
//        // Then update the line ranges
//        updateLineRanges(forCharactersReplacedInRange: range, with: str)
//        
//        // Check the line ranges in testing
//        //        checkLineRanges()
//        
//        edited(.editedCharacters, range: range, changeInLength: (str as NSString).length - range.length)
//        endEditing()
//    }
//    
//    private func updateLineRanges(forCharactersReplacedInRange range: NSRange, with str: String) {
//        // First remove the line start locations in the affected range
//        var line = 0
//        if range.length != 0 {
//            var foundFirstMatch = false
//            while line < lineRanges.count {
//                if range.contains(lineRanges[line].location - 1) {
//                    foundFirstMatch = true
//                    lineRanges.remove(at: line)
//                }
//                else if !foundFirstMatch {
//                    line += 1
//                }
//                else {
//                    break
//                }
//            }
//        }
//        
//        // Find the line index for where to insert any new line start locations
//        line = 0
//        while line < lineRanges.count && range.location > lineRanges[line].location - 1 {
//            line += 1
//        }
//        
//        // Find the new line start locations, adding the offset and 1 to get the location of the next line.
//        let newLineLocs = str.utf16.indices.filter{ str[$0] == "\n" }.map{
//            $0.utf16Offset(in: str) + 1 + range.location }
//        
//        // Create new line ranges with 0 length.
//        let newLineRanges = newLineLocs.map{ NSRange(location: $0, length: 0) }
//        lineRanges.insert(contentsOf: newLineRanges, at: line)
//        
//        // Shift the start locations after inserted ranges.
//        for i in line+newLineRanges.count..<lineRanges.count {
//            lineRanges[i].location += str.utf16.count - range.length
//        }
//        
//        // Update lengths of new ranges and the one before (as it may have changed)
//        for i in max(line-1, 0)..<min(lineRanges.count - 1, line+newLineRanges.count) {
//            lineRanges[i].length = lineRanges[i + 1].location - lineRanges[i].location
//        }
//        
//        // If the last line range is a new line range, we set the length based on the text storage.
//        if newLineRanges.count + line == lineRanges.count {
//            lineRanges[lineRanges.count - 1].length = storage.length - lineRanges[lineRanges.count - 1].location
//        }
//    }
//    
//    func checkLineRanges() {
//        assert(!lineRanges.isEmpty)
//        
//        var i = 0
//        while i < lineRanges.count-2 {
//            assert(lineRanges[i].upperBound == lineRanges[i+1].location)
//            i += 1
//        }
//        
//        if let lastNewLine = storage.string.lastIndex(of: "\n")?.utf16Offset(in: storage.string) {
//            assert(lineRanges.last!.length == storage.length - (lastNewLine + 1))
//        }
//        else {
//            assert(lineRanges.last?.length == storage.length)
//        }
//    }
//    
//    override public func setAttributes(_ attrs: [NSAttributedString.Key: Any]?, range: NSRange) {
//        beginEditing()
//        storage.setAttributes(attrs, range: range)
//        edited(.editedAttributes, range: range, changeInLength: 0)
//        endEditing()
//    }
//    
//    private func getEditedLines(lineStartLocs: [Int], editedRange: NSRange) -> (Int, Int) {
//        var first = 0
//        while first < lineStartLocs.count - 1 {
//            if editedRange.location < lineStartLocs[first+1] {
//                break
//            }
//            first += 1
//        }
//        
//        // We figure out the last line that was edited.
//        var last = first
//        while last < lineStartLocs.count - 1 {
//            if editedRange.upperBound <= lineStartLocs[last+1] {
//                break
//            }
//            last += 1
//        }
//        
//        return (first, last)
//    }
//}
//
//
//extension NSAttributedString {
//    
//    var fullRange: NSRange {
//        return NSRange(location: 0, length: length)
//    }
//}

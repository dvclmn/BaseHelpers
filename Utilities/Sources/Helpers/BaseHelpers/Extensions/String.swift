//
//  File.swift
//
//
//  Created by Dave Coleman on 10/8/2024.
//

import Foundation



public extension String {
  var wordCount: Int {
    let words = self.split { !$0.isLetter }
    return words.count
  }

  func nsRange(from range: Range<String.Index>) -> NSRange {
    return NSRange(range, in: self)
  }
  
  func range(from nsRange: NSRange) -> Range<String.Index>? {
    return Range(nsRange, in: self)
  }
  
  func substring(with nsRange: NSRange) -> Substring? {
    guard let range = self.range(from: nsRange) else { return nil }
    return self[range]
  }
  
  subscript(range: Range<Int>) -> Substring? {
    get {
      let start = index(startIndex, offsetBy: range.lowerBound)
      let end = index(start, offsetBy: range.count)
      
      return self[start..<end]
    }
  }
  
  subscript(range: NSRange) -> Substring? {
    get {
      return range.range(in: self).flatMap({ self[$0] })
    }
  }
  
  /// A `prefix(_ maxLength: Int)` alternative, returning a `String` rather than `Substring`
  ///
  func preview(_ maxLength: Int) -> String {
    return String(self.prefix(maxLength))
  }
  
  
  
}

extension NSString {
  func range(from range: Range<String.Index>) -> NSRange {
    let utf16Start = range.lowerBound.utf16Offset(in: self as String)
    let utf16End = range.upperBound.utf16Offset(in: self as String)
    return NSRange(location: utf16Start, length: utf16End - utf16Start)
  }
}



public extension Character {
  var string: String {
    String(self)
  }
}



/// This extension seems to drive something like the below (as found in Banksia, to highlight search terms)
/*
 
 var match: [String] {
 return [conv.searchText].filter { message.content.localizedCaseInsensitiveContains($0) }
 }
 
 var highlighted: AttributedString {
 var result = AttributedString(message.content)
 _ = match.map {
 let ranges = message.content.ranges(of: $0, options: [.caseInsensitive])
 ranges.forEach { range in
 result[range].backgroundColor = .orange.opacity(0.2)
 }
 }
 return result
 }
 
 */

//public extension StringProtocol {
//
//    func ranges<T: StringProtocol>(
//        of stringToFind: T,
//        options: String.CompareOptions = [],
//        locale: Locale? = nil
//    ) -> [Range<AttributedString.Index>] {
//
//        var ranges: [Range<String.Index>] = []
//        var attributedRanges: [Range<AttributedString.Index>] = []
//        let attributedString = AttributedString(self)
//
//        while let result = range(
//            of: stringToFind,
//            options: options,
//            range: (ranges.last?.upperBound ?? startIndex)..<endIndex,
//            locale: locale
//        ) {
//            ranges.append(result)
//            let start = AttributedString.Index(result.lowerBound, within: attributedString)!
//            let end = AttributedString.Index(result.upperBound, within: attributedString)!
//            attributedRanges.append(start..<end)
//        }
//        return attributedRanges
//    }
//}

//
//  Regex.swift
//  Collection
//
//  Created by Dave Coleman on 14/2/2025.
//


import Foundation

extension NSRegularExpression.Options: @retroactive CustomStringConvertible {
  public var description: String {
    var options: [String] = []
    
    if contains(.caseInsensitive) { options.append("caseInsensitive") }
    if contains(.allowCommentsAndWhitespace) { options.append("allowCommentsAndWhitespace") }
    if contains(.ignoreMetacharacters) { options.append("ignoreMetacharacters") }
    if contains(.dotMatchesLineSeparators) { options.append("dotMatchesLineSeparators") }
    if contains(.anchorsMatchLines) { options.append("anchorsMatchLines") }
    if contains(.useUnixLineSeparators) { options.append("useUnixLineSeparators") }
    if contains(.useUnicodeWordBoundaries) { options.append("useUnicodeWordBoundaries") }
    
    return options.isEmpty ? "[]" : "[\(options.joined(separator: ", "))]"
  }
}

extension NSRegularExpression.MatchingOptions: @retroactive CustomStringConvertible {
  public var description: String {
    var options: [String] = []
    
    if contains(.reportProgress) { options.append("reportProgress") }
    if contains(.reportCompletion) { options.append("reportCompletion") }
    if contains(.anchored) { options.append("anchored") }
    if contains(.withTransparentBounds) { options.append("withTransparentBounds") }
    if contains(.withoutAnchoringBounds) { options.append("withoutAnchoringBounds") }
    
    return options.isEmpty ? "[]" : "[\(options.joined(separator: ", "))]"
  }
}


public extension NSRegularExpression {
  func matches(in string: String, options: NSRegularExpression.MatchingOptions = []) -> [NSTextCheckingResult] {
    return matches(in: string, options: options, range: NSRange(location: 0, length: string.utf16.count))
  }
  
  func firstMatch(in string: String, options: NSRegularExpression.MatchingOptions = []) -> NSTextCheckingResult? {
    return firstMatch(in: string, options: options, range: NSRange(location: 0, length: string.utf16.count))
  }
}

//
//  NSRegularExpresion.swift
//  TextCore
//
//  Created by Dave Coleman on 12/10/2024.
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

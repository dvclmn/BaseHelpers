//
//  FuzzySearch.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 23/5/2025.
//

import Foundation
import Ifrit

public protocol FuzzyResultsHandler: Sendable {
  associatedtype Item: FuzzySearchable

  var fuse: Fuse { get }
  var searchQuery: String { get set }
  var debouncer: AsyncDebouncer { get }
  var collection: [Item] { get }
  func results() async -> [FuzzyMatch<Item>]
}

extension FuzzyResultsHandler {

  public var allItems: [FuzzyMatch<Item>] {
    collection.map { item in
      return FuzzyMatch(
        item: item,
        score: 0,
        ranges: []
      )
    }
  }

  public func results() async -> [FuzzyMatch<Item>] {
    guard !searchQuery.isEmpty else {
      return allItems
    }

    return await debouncer.execute {
      let matches = collection.compactMap { item in
        item.fuzzyMatch(using: fuse, query: searchQuery)
      }
      let sorted = matches.sorted { $0.score < $1.score }
      return sorted
    } ?? []
  }


}

public protocol FuzzySearchable: Sendable, Identifiable {
  var stringRepresentation: String { get }
  /// Called with the fuse instance and the query, returns a FuzzyMatch if this item matched.
  func fuzzyMatch(using fuse: Fuse, query: String) -> FuzzyMatch<Self>?
}

public typealias FuzzyRanges = [CountableClosedRange<Int>]

public struct FuzzyMatch<Item: FuzzySearchable>: Sendable {

  public let item: Item
  public let score: Double
  public let ranges: FuzzyRanges


  public init(
    item: Item,
    score: Double,
    ranges: FuzzyRanges
  ) {
    self.item = item
    self.score = score
    self.ranges = ranges
  }

  public func itemTitle(
    with container: AttributeContainer = .highlighter
  ) -> AttributedString {

    //    let theme = MarkdownTheme.defaultTheme
//    let markdownRanges = getCachedMarkdownRanges(
//      for: item.stringRepresentation,
//      theme: theme,
//      forSyntax: Markdown.Syntax.testCases
//    )
    
    
//    public typealias StyledRanges = [Markdown.Syntax: [Range<AttributedString.Index>]]
//    
//    public struct MarkdownRanges {
//      public var ranges: StyledRanges
//      public var text: AttributedString
//      public init(
//        ranges: StyledRanges,
//        text: AttributedString
//      ) {
//        self.ranges = ranges
//        self.text = text
//      }
//    }
    
    
    var attrString = AttributedString(item.stringRepresentation)
    
//    var rangeDict: StyledRanges = [:]
    
//    for type in syntax {
//      guard let regex = type.regexLiteral else { continue }
//      let string = text
    
    
    
    
    
//      let matches = string.matches(of: regex)
//      
//      var ranges: [Range<AttributedString.Index>] = []
//      for match in matches {
//        guard let fullRange = attrString.range(of: match.output.0) else { continue }
//        attrString[fullRange].setAttributes(AttributeContainer.fromTheme(theme, for: type))
//        ranges.append(fullRange)
//      }
//      
//      if !ranges.isEmpty {
//        rangeDict[type] = ranges
//      }
    
    
    
    
    
//    }
    
    /// Cache the results
    //      markdownCache[text] = rangeDict
//    return MarkdownRanges(ranges: rangeDict, text: attrString)

    
//    var attributedString = markdownRanges.text

    /// Loop through each matching range from Fuse.
    for range in self.ranges {
      /// Convert the `CountableClosedRange<Int>` into a `Range<AttributedString.Index>`
      if let start = attrString.index(at: range.lowerBound),
        let end = attrString.index(at: range.upperBound + 1)
      {
        let attributedRange = start..<end

        /// Apply the desired styling (here using .neonOrange as defined).
        attrString[attributedRange].mergeAttributes(.searchMatch)
      }
    }

    return attrString
  }

//  #warning("Nothing is being cached at the moment, I think")
//  func getCachedMarkdownRanges(
//    for text: String,
//    theme: MarkdownTheme,
//    forSyntax syntax: [Markdown.Syntax]
//  ) -> MarkdownRanges {
//
//    /// Update last access time
//    //    lastAccessTimes[text] = Date()
//
//    /// Trim cache if needed
//    //    trimCacheIfNeeded()
//    //
//    //    if let cached = markdownCache[text] {
//    //      /// Create a new AttributedString but use cached ranges
//    //      var attrString = AttributedString(text)
//    //      for (syntax, ranges) in cached {
//    //        for range in ranges {
//    //          attrString[range].setAttributes(AttributeContainer.fromTheme(theme, for: syntax))
//    //        }
//    //      }
//    //      return MarkdownRanges(ranges: cached, text: attrString)
//    //    } else {
//    /// Parse and cache new content
//    var attrString = AttributedString(text)
//    var rangeDict: StyledRanges = [:]
//
//    for type in syntax {
//      guard let regex = type.regexLiteral else { continue }
//      let string = text
//      let matches = string.matches(of: regex)
//
//      var ranges: [Range<AttributedString.Index>] = []
//      for match in matches {
//        guard let fullRange = attrString.range(of: match.output.0) else { continue }
//        attrString[fullRange].setAttributes(AttributeContainer.fromTheme(theme, for: type))
//        ranges.append(fullRange)
//      }
//
//      if !ranges.isEmpty {
//        rangeDict[type] = ranges
//      }
//    }
//
//    /// Cache the results
//    //      markdownCache[text] = rangeDict
//    return MarkdownRanges(ranges: rangeDict, text: attrString)
//  }
}

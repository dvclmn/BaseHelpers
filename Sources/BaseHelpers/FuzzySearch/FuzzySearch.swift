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

    var attrString = AttributedString(item.stringRepresentation)
   
    /// Loop through each matching range from Fuse.
    for range in self.ranges {
      /// Convert the `CountableClosedRange<Int>` into a `Range<AttributedString.Index>`
      if let start = attrString.index(at: range.lowerBound),
        let end = attrString.index(at: range.upperBound + 1)
      {
        let attributedRange = start..<end

        /// Apply the desired styling (here using .neonOrange as defined).
        attrString[attributedRange].mergeAttributes(container)
      }
    }

    return attrString
  }
}

//
//  FuzzySearchable.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 21/9/2025.
//

import Foundation

public typealias FuzzyRanges = [CountableClosedRange<Int>]

public protocol FuzzySearchable: LabeledItem, Sendable, Identifiable {
  associatedtype Provider: FuzzyProvider
  var stringRepresentation: String { get }

  /// Called with the fuse instance and the query, returns a `FuzzyMatch` if this item matched.
  /// E.g. `provider: Fuse`
  func fuzzyMatch(using provider: Provider, query: String) -> FuzzyMatch<Self>?

  func styledLabel(
    ranges: FuzzyRanges?,
    with container: AttributeContainer
  ) -> QuickLabel

}

extension FuzzySearchable {

  public func fuzzyMatch(
    using provider: Provider,
    query: String
  ) -> FuzzyMatch<Self>? {
    let scoredRanges: ScoredRanges? = provider.searchSync(
      query,
      in: self.stringRepresentation
    )
    guard let scoredRanges else { return nil }
    return FuzzyMatch(
      item: self,
      score: scoredRanges.score,
      ranges: scoredRanges.ranges
    )
  }

  public func styledLabel(
    ranges: FuzzyRanges?,
    with container: AttributeContainer = .highlighter
  ) -> QuickLabel {

    guard let ranges else { return self.label }
    var attrString = AttributedString(self.stringRepresentation)

    /// Loop through each matching range from Fuse.
    for range in ranges {

      /// Convert the `CountableClosedRange<Int>` into a `Range<AttributedString.Index>`
      if let attrRange = range.attributedRange(for: attrString) {
        /// Apply the desired styling
        attrString[attrRange].mergeAttributes(container)
      }
    }

    return QuickLabel(
      attrString,
      icon: self.label.icon,
      role: self.label.role
    )
  }
}

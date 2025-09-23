//
//  FuzzyMatch.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 21/9/2025.
//

import Foundation

public struct FuzzyMatch<Item: FuzzySearchable>: Sendable, Identifiable {
  public var id: Item.ID { item.id }
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
}


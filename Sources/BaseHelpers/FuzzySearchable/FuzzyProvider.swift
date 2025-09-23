//
//  FuzzyProvider.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 21/9/2025.
//

import Foundation

/// Avoiding importing iFrit as dependancy, it'll need to conform to this
public protocol FuzzyProvider {
//  associatedtype Prop: SearchableProperty

//  func searchSync<S: Sequence>(
//    _ text: String,
//    in aList: S
//  ) -> [SearchResult] where S.Element == [Prop]
  
  func searchSync(
    _ text: String,
    in aString: String
  ) -> ScoredRanges?
}

public typealias ScoredRanges = (
  score: Double,
  ranges: FuzzyRanges
)


//public protocol SearchableProperty: Sendable {
//  var value: String { get }
//  var weight: Double { get }
//  
//  /// Default weight = 1.0
//  init(_ value: String, weight: Double)
//}

//public typealias SearchResult = (
//  index: Int,
//  diffScore: Double,
//  results: [(
//    value: String,
//    diffScore: Double,
//    ranges: [CountableClosedRange<Int>]
//  )]
//)

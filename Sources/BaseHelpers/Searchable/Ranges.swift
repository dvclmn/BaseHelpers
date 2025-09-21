//
//  Ranges.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 21/9/2025.
//

import Foundation

public typealias ScoredRanges = (
  score: Double,
  ranges: FuzzyRanges
)

public typealias FuzzyRanges = [CountableClosedRange<Int>]

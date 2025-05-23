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
  var searchQuery: String { get }
  var debouncer: AsyncDebouncer { get }
  var collection: [Item] { get }
  
  func results() async -> [FuzzyMatch<Item>]
}
extension FuzzyResultsHandler {
  
  var allItems: [FuzzyMatch<Item>] {
    collection.map { item in
      return FuzzyMatch(
        item: item,
        score: 0,
        ranges: []
      )
    }
  }
  
  func results() async -> [FuzzyMatch<Item>] {
    
    guard !searchQuery.isEmpty else {
      return allItems
    }
    
    return await debouncer.execute {
      let matches = collection.compactMap { item in
        item.fuzzyMatch(using: fuse, query: searchQuery)
      }
      return matches.sorted { $0.score < $1.score }
    } ?? []
    
    
    
    
//    return await debouncer.execute { @MainActor in
//      print("Debounced results called")
//      
//      let matches = collection.compactMap { item in
//        item.fuzzyMatch(using: fuse, query: searchQuery)
//      }
//      
//      return matches.sorted(by: { $0.score < $1.score })
//    }
//    await debouncer.execute { @MainActor in
//      print("Debounced results called")
//      
//      // Some kind of provided transformation/mapping here...
//      
//      let sortedMatches = matches.sorted { $0.score < $1.score }
//      // etc...
//    }
//    return []
  }
  
  
}

public protocol FuzzySearchable: Sendable {
  var stringRepresentation: String { get }
  /// Called with the fuse instance and the query, returns a FuzzyMatch if this item matched.
  func fuzzyMatch(using fuse: Fuse, query: String) -> FuzzyMatch<Self>?
}

public typealias FuzzyRanges = [CountableClosedRange<Int>]

public struct FuzzyMatch<Item: FuzzySearchable> : Sendable{
  let item: Item
  let score: Double
  let ranges: FuzzyRanges
}


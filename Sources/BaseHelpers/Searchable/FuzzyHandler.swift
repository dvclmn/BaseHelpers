//
//  FuzzyHandler.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 21/9/2025.
//

import Foundation

@MainActor
public protocol FuzzySearchHandler: Sendable, AnyObject {
  associatedtype Provider: FuzzyProvider
  associatedtype Item: FuzzySearchable & LabeledItem
  
  var provider: Provider { get }
  var collection: [Item] { get }
  var searchString: String { get set }
  var searchDebouncer: AsyncDebouncer { get }
  var selectedResult: FuzzyMatch<Item>.ID? { get set }
  var isSearchPresented: Bool { get set }
  var searchState: SearchState<Item>? { get set }
  var layoutMode: LayoutMode { get set }
  func fetchResults() async -> SearchState<Item>
}

extension FuzzySearchHandler {

  public func fetchResults() async -> SearchState<Item> {
    guard !searchString.isEmpty else {
      print("No search string")
      return .noSearchString
    }
    self.searchState = SearchState<Item>.searching(.loading)
    
    let results: [FuzzyMatch<Item>]? = await searchDebouncer.execute { @MainActor in
      let matches = self.collection.compactMap { item in
        item.fuzzyMatch(using: self.provider, query: self.searchString)
      }
      let sorted = matches.sorted { $0.score < $1.score }
      return sorted
    }
    guard let results else {
      return SearchState<Item>.searching(.noResults)
      
    }
    return SearchState<Item>.searching(.hasResults(results))
  }
  
}

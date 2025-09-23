//
//  SearchState.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 21/9/2025.
//

import Foundation

public enum SearchState<Item: FuzzySearchable> {
  /// No search UI needed, View is hidden
  //  case notPresented
  
  /// The first view the user will see, ready for searching
  case noSearchString
  
  /// Search is presented, user is entered a query (searching...)
  case searching(Self.Results)
  
  public enum Results {
    case loading
    case noResults
    case hasResults([FuzzyMatch<Item>])
  }
}


//
//  FilterSorter.swift
//  Collection
//
//  Created by Dave Coleman on 15/10/2024.
//

import ComposableArchitecture
import Foundation

public protocol IdentifiedElement: Identifiable {
  var name: String { get }
}

@Reducer
public struct FilterSorter<Element: IdentifiedElement> {
  
  @ObservableState
  public struct State {
    var originalElements: IdentifiedArrayOf<Element>
    var filteredElements: IdentifiedArrayOf<Element>
    var searchText: String = ""
    var sortDescriptors: [SortDescriptor<Element>] = []
    var filterPredicate: ((Element) -> Bool)?
  }
  
  public enum Action {
    case setSearchText(String)
    case setSortDescriptors([SortDescriptor<Element>])
    case setFilterPredicate((Element) -> Bool)
    case applyFilterAndSort
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
        case let .setSearchText(text):
          state.searchText = text
          return .send(.applyFilterAndSort)
          
        case let .setSortDescriptors(descriptors):
          state.sortDescriptors = descriptors
          return .send(.applyFilterAndSort)
          
        case let .setFilterPredicate(predicate):
          state.filterPredicate = predicate
          return .send(.applyFilterAndSort)
          
        case .applyFilterAndSort:
          var filtered = state.originalElements
          
          // Apply search filter
          if !state.searchText.isEmpty {
            filtered = IdentifiedArrayOf(uniqueElements: filtered.filter { element in

              return element.name.localizedCaseInsensitiveContains(state.searchText)
            })
          }
          
          // Apply custom filter
          if let predicate = state.filterPredicate {
            filtered = IdentifiedArrayOf(uniqueElements: filtered.filter(predicate))
          }
          
          // Apply sort
          let sorted = filtered.sorted(using: state.sortDescriptors)
          state.filteredElements = IdentifiedArrayOf(uniqueElements: sorted)
          
          return .none
      }
    }
  }
}

public extension FilterSorter {
  // Helper to create a SortDescriptor for a KeyPath
  func sortDescriptor<Root, Value: Comparable>(
    _ keyPath: KeyPath<Root, Value>,
    order: SortOrder = .forward
  ) -> SortDescriptor<Root> {
    return SortDescriptor(keyPath, order: order)
  }
}

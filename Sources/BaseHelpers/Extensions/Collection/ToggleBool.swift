//
//  ToggleBool.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 28/9/2025.
//

import Foundation

/// Determines the target state when toggling a collection of boolean values
public enum ToggleStrategy {
  /// If all same state, toggle. If mixed, set all to true
  case preferTrue
  
  /// If all same state, toggle. If mixed, set all to false
  case preferFalse
  
  /// If all same state, toggle. If mixed, set to majority state
  case followMajority
  
  /// Invert the state of each toggle to its opposite
  case invert(collection: [Bool])
}

/// Usage examples:
/// ```
/// extension Collection where Element == Bool {
///   // Convenience method that combines the logic for easy use
///   func shouldToggleIndividually(strategy: ToggleStrategy = .preferTrue) -> Bool {
///     return toggleAction(strategy: strategy) == nil
///   }
/// }
/// ```
extension Collection where Element == Bool {

  /// Convenience method that combines the logic for easy use
//  func shouldToggleIndividually(strategy: ToggleStrategy = .preferTrue) -> Bool {
//    return toggleAction(strategy: strategy) == nil
//  }

  /// Determines what boolean value to set all items to based on current states
  /// - Parameter strategy: How to handle mixed states
  /// - Returns: The target boolean value for all items
  public func toggleTarget(strategy: ToggleStrategy = .preferTrue) -> Bool {
    guard !isEmpty else { return true }

    let trueCount = filter { $0 }.count
    let falseCount = count - trueCount
    let allTrue = trueCount == count
    let allFalse = falseCount == count

    switch strategy {
      case .preferTrue:
        return allTrue ? false : true

      case .preferFalse:
        return allFalse ? true : false

      case .followMajority:
        if allTrue { return false }
        if allFalse { return true }
        return trueCount > falseCount ? true : false

      case .invert(let collection):
        return collection.map { !$0 }
//        collection.map { $0.toggle() }
        // This case doesn't return a single target - caller should toggle individually
//        fatalError("toggleAll strategy requires individual toggling, not a single target value")
    }
  }

  /// Determines whether items should be toggled individually or set to a uniform value
  /// - Parameter strategy: How to handle the toggle operation
  /// - Returns: nil if items should toggle individually, Bool value if all should be set to that value
  public func toggleAction(
    current: [Bool],
    strategy: ToggleStrategy = .preferTrue
  ) -> Bool? {
    
    guard !isEmpty else { return true }
    
    
    
    if let targetValue = current.toggleAction(strategy: toggleStrategy) {
      /// Set all to the same target value
      for id in affectedIDs {
        
        lib.userData[id, default: UserData.defaultData(for: id)][keyPath: keyPath] = targetValue
      }
    } else {
      /// Toggle each individually (only for .toggleAll strategy)
      for id in affectedIDs {
        let defaultData = UserData(id: id, isInLibrary: false)
        lib.userData[id, default: defaultData][keyPath: keyPath].toggle()
      }
    }
    
    
    
    

    switch strategy {
      case .toggleAll:
        return nil  // Indicates: toggle each individually

      case .preferTrue, .preferFalse, .followMajority:
        return toggleTarget(strategy: strategy)
    }
  }
}

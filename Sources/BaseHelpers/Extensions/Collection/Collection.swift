//
//  Collection.swift
//  Collection
//
//  Created by Dave Coleman on 17/12/2024.
//

extension Collection {
  
  public func hasIndex(_ offset: Int) -> Bool {
    let startIndex = self.startIndex
    let endIndex = self.endIndex
    guard let index = self.index(startIndex, offsetBy: offset, limitedBy: endIndex) else {
      return false
    }
    return index < endIndex
  }
  
  public var toArray: [Element] {
    return Array(self)
  }
}

extension Collection where Index == Int {

  /// Core index calculation logic - reusable across different collection types
  public func nextIndex(
    after index: Int,
    wrapping: Bool = true
  ) -> Int? {
    let nextIdx = index + 1
    guard wrapping else {
      return nextIdx < count ? nextIdx : nil
    }
    return nextIdx % count
  }
  
  public func previousIndex(
    before index: Int,
    wrapping: Bool = true
  ) -> Int? {
    let prevIdx = index - 1
    guard wrapping else {
      return prevIdx >= 0 ? prevIdx : nil
    }
    return (prevIdx + count) % count
  }
}

/// Determines the target state when toggling a collection of boolean values
public enum ToggleStrategy {
  /// If all same state, toggle. If mixed, set all to true
  case preferTrue
  /// If all same state, toggle. If mixed, set all to false
  case preferFalse
  /// If all same state, toggle. If mixed, set to majority state
  case followMajority
  /// Always toggle all items individually
  case toggleAll
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
  func shouldToggleIndividually(strategy: ToggleStrategy = .preferTrue) -> Bool {
    return toggleAction(strategy: strategy) == nil
  }

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

      case .toggleAll:
        // This case doesn't return a single target - caller should toggle individually
        fatalError("toggleAll strategy requires individual toggling, not a single target value")
    }
  }

  /// Determines whether items should be toggled individually or set to a uniform value
  /// - Parameter strategy: How to handle the toggle operation
  /// - Returns: nil if items should toggle individually, Bool value if all should be set to that value
  public func toggleAction(
    strategy: ToggleStrategy = .preferTrue
  ) -> Bool? {
    guard !isEmpty else { return true }

//    let allSameState: Bool = allSatisfy { $0 == first }

    switch strategy {
      case .toggleAll:
        return nil  // Indicates: toggle each individually

      case .preferTrue, .preferFalse, .followMajority:
        return toggleTarget(strategy: strategy)
    }
  }
}

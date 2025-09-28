//
//  CyclicCollection.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 19/9/2025.
//

import Foundation

//extension Array: CyclicCollection {}

/// Anything that can move forwards/backwards through its elements.
//public protocol CyclicCollection: RandomAccessCollection where Index == Int {
//  /// Returns the element at `index` advanced by one step.
//  func element(after index: Int, wrapping: Bool) -> Element?
//  func element(before index: Int, wrapping: Bool) -> Element?
//}

//extension RandomAccessCollection where Element: Equatable {
//  public func nextElement(after element: Element, wrapping: Bool = true) -> Element? {
//    guard let i = firstIndex(of: element) else { return nil }
//    return self.element(after: i, wrapping: wrapping)
//  }
//  
//  public func previousElement(before element: Element, wrapping: Bool = true) -> Element? {
//    guard let i = firstIndex(of: element) else { return nil }
//    return self.element(before: i, wrapping: wrapping)
//  }
//}

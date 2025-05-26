//
//  Cyclable.swift
//  BaseComponents
//
//  Created by Dave Coleman on 14/5/2025.
//

import Foundation

public protocol Cyclable: LabeledEnum
where Self.AllCases.Index == Int {
  
  static var defaultCase: Self { get }
}

extension Cyclable {
  public func next() -> Self {
    let allCases = Self.allCases
    guard let currentIndex: Int = allCases.firstIndex(of: self) else {
      return Self.defaultCase
    }
    let nextIndex: Int = (currentIndex + 1) % allCases.count
    return allCases[nextIndex]
  }
  
  public func previous() -> Self {
    let allCases = Self.allCases
    guard let currentIndex = allCases.firstIndex(of: self) else {
      return Self.defaultCase
    }
    let previousIndex = (currentIndex - 1 + allCases.count) % allCases.count
    return allCases[previousIndex]
  }
}

// I don't yet know how to take advantage of the below (suggestions from GPT 4.1)
//public struct CyclableCollection<T: Cyclable>: RandomAccessCollection {
//  let base = T.allCases
//  
//  public init() {}
//  public var startIndex: T.AllCases.Index { base.startIndex }
//  public var endIndex: T.AllCases.Index { base.endIndex }
//  
//  public subscript(position: T.AllCases.Index) -> T {
//    base[position]
//  }
//  
//  public func index(after i: T.AllCases.Index) -> T.AllCases.Index {
//    base.index(after: i)
//  }
//  
//  public func index(before i: T.AllCases.Index) -> T.AllCases.Index {
//    base.index(before: i)
//  }
//}
//
//
//public struct ItemFilter<T: Cyclable> {
//  
//  public var isIncluded: (T) -> Bool
//  
//  public init(_ isIncluded: @escaping (T) -> Bool) {
//    self.isIncluded = isIncluded
//  }
//  
//  public func filtered(_ collection: some Collection<T>) -> [T] {
//    collection.filter(isIncluded)
//  }
//  
//  public static var all: Self {
//    .init { _ in true }
//  }
//  
//  public func next(after current: T, in all: some Collection<T>) -> T {
//    let filtered = filtered(all)
//    guard let index = filtered.firstIndex(of: current) else {
//      return filtered.first ?? T.defaultCase
//    }
//    return filtered[(index + 1) % filtered.count]
//  }
//  
//  public func previous(before current: T, in all: some Collection<T>) -> T {
//    let filtered = filtered(all)
//    guard let index = filtered.firstIndex(of: current) else {
//      return filtered.first ?? T.defaultCase
//    }
//    return filtered[(index - 1 + filtered.count) % filtered.count]
//  }
//}


//public struct EnumCycler<T: Cyclable> {
//  private let items: [T]
//  
//  public init(
//    source: [T] = Array(T.allCases),
//    filter: ItemFilter<T> = .all
//  ) {
//    self.items = filter.filtered(source)
//  }
//  
//  public func next(after current: T) -> T {
//    guard let index = items.firstIndex(of: current) else { return T.defaultCase }
//    return items[(index + 1) % items.count]
//  }
//  
//  public func previous(before current: T) -> T {
//    guard let index = items.firstIndex(of: current) else { return T.defaultCase }
//    return items[(index - 1 + items.count) % items.count]
//  }
//  
//  public var all: [T] { items }
//}

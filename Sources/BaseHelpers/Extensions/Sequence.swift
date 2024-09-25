//
//  Sequence.swift
//  Collection
//
//  Created by Dave Coleman on 25/9/2024.
//


public extension Sequence where Element: Identifiable {
  
  func mostRecent<T: Comparable>(
    by dateKeyPath: KeyPath<Element, T>
  ) -> Element? {
    
    self.max(by: { $0[keyPath: dateKeyPath] < $1[keyPath: dateKeyPath] })
    
  }
  
}

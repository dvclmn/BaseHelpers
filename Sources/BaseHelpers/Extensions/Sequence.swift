//
//  Sequence.swift
//  Collection
//
//  Created by Dave Coleman on 25/9/2024.
//

import Foundation

extension Sequence where Element: Identifiable {

  public func mostRecent<T: Comparable>(
    by dateKeyPath: KeyPath<Element, T>
  ) -> Element? {

    self.max(by: { $0[keyPath: dateKeyPath] < $1[keyPath: dateKeyPath] })

  }

}

extension Sequence {
  public func summarise<T: CustomStringConvertible>(
    key: KeyPath<Element, T>,
    delimiter: Character? = ","
  ) -> String {
    return self.map { $0[keyPath: key].description }
      .enumerated()
      .reduce(into: "") { (result, element) in
        let (index, value) = element
        if index > 0 {
          if let delimiter {
            result += "\(delimiter) "
          }
        }
        result += value
      }
  }

  public func sorted<T: Comparable>(
    by keyPath: KeyPath<Element, T>,
    using comparator: (T, T) -> Bool = (<)
  ) -> [Element] {
    sorted { a, b in
      comparator(a[keyPath: keyPath], b[keyPath: keyPath])
    }
  }
  
//  public func grouping(by keyPath: KeyPath<Element, T>) -> Dictionary<Self> {
//    
//  }
//  public func grouping(by keyPath: KeyPath<Element, Int>) ->

}

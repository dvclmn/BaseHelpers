//
//  Sequence.swift
//  Collection
//
//  Created by Dave Coleman on 25/9/2024.
//

import Foundation

public extension Sequence where Element: Identifiable {
  
  func mostRecent<T: Comparable>(
    by dateKeyPath: KeyPath<Element, T>
  ) -> Element? {
    
    self.max(by: { $0[keyPath: dateKeyPath] < $1[keyPath: dateKeyPath] })
    
  }
  
}

public extension Sequence {
  func summarise<T: CustomStringConvertible>(
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
}

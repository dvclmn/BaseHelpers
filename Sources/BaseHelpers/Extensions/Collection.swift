//
//  Collection.swift
//  Collection
//
//  Created by Dave Coleman on 17/12/2024.
//

extension Collection {
  //  func hasIndex(_ index: Int) -> Bool {
  //    self.indices.contains(index)
  //  }

  public func hasIndex(_ offset: Int) -> Bool {
    let startIndex = self.startIndex
    let endIndex = self.endIndex
    guard let index = self.index(startIndex, offsetBy: offset, limitedBy: endIndex) else {
      return false
    }
    return index < endIndex
  }

  

}

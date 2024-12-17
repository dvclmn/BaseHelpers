//
//  Collection.swift
//  Collection
//
//  Created by Dave Coleman on 17/12/2024.
//

public extension Collection where Index == Int {
  func hasIndex(_ index: Int) -> Bool {
    self.indices.contains(index)
  }
}

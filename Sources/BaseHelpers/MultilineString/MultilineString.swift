//
//  MultilineString.swift
//  TextCore
//
//  Created by Dave Coleman on 14/9/2024.
//

import Foundation

public enum TrimMethod {
  case leaveSpace
  case crop
}

public struct MultilineString {

  private var grid: [[Character]]

  public init(_ grid: [[Character]]) {
    self.grid = grid
  }

  public init(_ string: String) {
    self.init(string.lines.map { Array($0) })
  }


}

extension MultilineString {


  public var string: String {
    grid.map { String($0) }.joined(separator: "\n")
  }


  public var height: Int {
    grid.count
  }

  public var width: Int {
    grid.map { $0.count }.max() ?? 0
  }

  public subscript(row: Int) -> [Character] {
    get {
      guard row < grid.count else { return [] }
      return grid[row]
    }
    set {
      if row < grid.count {
        grid[row] = newValue
      } else if row == grid.count {
        grid.append(newValue)
      }
    }
  }

  public var isEmpty: Bool {
    grid.isEmpty || grid.allSatisfy { $0.isEmpty }
  }

}

extension MultilineString: ExpressibleByArrayLiteral {
  public init(arrayLiteral elements: [Character]...) {
    self.grid = elements
  }

}

extension MultilineString: CustomStringConvertible {
  public var description: String {
    self.string
  }
}

extension MultilineString: Sequence {

  public func makeIterator() -> IndexingIterator<[[Character]]> {
    grid.makeIterator()
  }

  public func map<T>(_ transform: ([Character]) -> T) -> [T] {
    grid.map(transform)
  }

  public func enumerated() -> EnumeratedSequence<[[Character]]> {
    grid.enumerated()
  }


  mutating func append(_ row: [Character]) {
    grid.append(row)
  }

}

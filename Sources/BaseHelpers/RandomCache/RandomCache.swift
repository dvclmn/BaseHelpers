//
//  RandomCache.swift
//  Collection
//
//  Created by Dave Coleman on 11/12/2024.
//

import Foundation

/// Protocol for different types of cached random values
public protocol CacheableRandomValues {
  /// Unique identifier for this cache type
  var cacheKey: String { get }
}

/// Manages cached random values with type safety
public struct RandomCache {
  private var values: [String: Any] = [:]
  private var generator: RandomNumberGenerator
  
  public init(seed: UInt64) {
    self.generator = SeededGenerator(seed: seed)
  }
  
  /// Store or retrieve cached values
  public mutating func values<T: CacheableRandomValues>(
    of type: T.Type,
    count: Int,
    generator: (inout RandomNumberGenerator) -> T
  ) -> T {
    let key = "\(type.self)_\(count)"
    
    if let cached = values[key] as? T {
      return cached
    }
    
    let newValues = generator(&self.generator)
    values[key] = newValues
    return newValues
  }
  
  public mutating func reset() {
    values.removeAll()
  }
}

/// Seeded random number generator
public struct SeededGenerator: RandomNumberGenerator {
  init(seed: UInt64) {
    srand48(Int(seed))
  }
  
  public func next() -> UInt64 {
    UInt64(drand48() * Double(UInt64.max))
  }
}

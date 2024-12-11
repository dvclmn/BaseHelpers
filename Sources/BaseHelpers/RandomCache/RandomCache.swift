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

/// Protocol for types that can be randomly generated
public protocol RandomGeneratable {
  associatedtype Value: BinaryFloatingPoint
  
  /// Generate a new set of random values using the provided generator
  static func generate(
    count: Int,
    using generator: inout RandomNumberGenerator,
    parameters: RandomisationParameters
  ) -> Self
}

/// Container for parameters that influence random generation
public struct RandomisationParameters {
  public var ranges: [ClosedRange<Double>]
  public var additionalParams: [String: Any]
  
  public init(
    ranges: [ClosedRange<Double>] = [],
    additionalParams: [String: Any] = [:]
  ) {
    self.ranges = ranges
    self.additionalParams = additionalParams
  }
}

/// Generic cache for random values
public struct RandomCache<T: RandomGeneratable> {
  private var values: [String: T] = [:]
  private var generator: RandomNumberGenerator
  
  public init(seed: UInt64) {
    self.generator = SeededGenerator(seed: seed)
  }
  
  /// Get or generate cached values
  public mutating func values(
    count: Int,
    parameters: RandomisationParameters,
    cacheKey: String? = nil
  ) -> T {
    let key = cacheKey ?? "\(count)_\(parameters.hashValue)"
    
    if let cached = values[key] {
      return cached
    }
    
    let newValues = T.generate(
      count: count,
      using: &generator,
      parameters: parameters
    )
    values[key] = newValues
    return newValues
  }
  
  public mutating func reset() {
    values.removeAll()
  }
}

/// Generic random value generator that can be extended for specific use cases
public struct RandomValueGenerator<T: RandomGeneratable> {
  private var cache: RandomCache<T>
  
  public init(seed: UInt64) {
    self.cache = RandomCache(seed: seed)
  }
  
  public mutating func generate(
    count: Int,
    parameters: RandomisationParameters,
    cacheKey: String? = nil
  ) -> T {
    cache.values(
      count: count,
      parameters: parameters,
      cacheKey: cacheKey
    )
  }
  
  public mutating func reset() {
    cache.reset()
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

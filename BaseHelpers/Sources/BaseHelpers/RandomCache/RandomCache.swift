//
//  RandomCache.swift
//  Collection
//
//  Created by Dave Coleman on 11/12/2024.
//

import Foundation

/// A protocol that defines types capable of generating random values.
///
/// Types conforming to `RandomGeneratable` must implement a method to generate random values
/// based on specified parameters and a random number generator.
///
/// - Note: The associated `Value` type must conform to `BinaryFloatingPoint` to ensure
///         compatibility with floating-point random operations.
///
public protocol RandomGeneratable {
  associatedtype Value: BinaryFloatingPoint
  
  /// Generates a new instance with random values.
  /// - Parameters:
  ///   - count: The number of random values to generate.
  ///   - generator: The random number generator to use.
  ///   - parameters: Parameters that influence the random generation.
  /// - Returns: A new instance containing the generated random values.
  static func generate(
    count: Int,
    using generator: inout RandomNumberGenerator,
    parameters: RandomisationParameters
  ) -> Self
}

/// A container for parameters that influence random value generation.
///
/// This structure holds both numeric ranges and additional parameters that may affect
/// the random generation process.
public struct RandomisationParameters: Hashable {
  /// Ranges that define the bounds for random value generation.
  public var ranges: [ClosedRange<Double>]
  
  /// Additional parameters that may influence the random generation process.
  public var additionalParams: [String: AnyHashable]
  
  /// Creates a new instance of randomisation parameters.
  /// - Parameters:
  ///   - ranges: Array of closed ranges defining bounds for random values.
  ///   - additionalParams: Dictionary of named parameters that may influence generation.
  public init(
    ranges: [ClosedRange<Double>] = [],
    additionalParams: [String: AnyHashable] = [:]
  ) {
    self.ranges = ranges
    self.additionalParams = additionalParams
  }
}

/// A cache system for storing and retrieving randomly generated values.
///
/// The cache uses a combination of count and parameters to create unique keys for storing values,
/// ensuring consistent results for identical inputs within the same session.
public struct RandomCache<T: RandomGeneratable> {
  private var values: [String: T] = [:]
  private var generator: RandomNumberGenerator
  
  /// Creates a new random cache with a specified seed.
  /// - Parameter seed: The seed value for the random number generator.
  public init(seed: UInt64) {
    self.generator = SeededGenerator(seed: seed)
  }
  
  /// Retrieves or generates cached values based on the provided parameters.
  /// - Parameters:
  ///   - count: The number of random values needed.
  ///   - parameters: Parameters influencing the generation.
  ///   - cacheKey: Optional custom key for caching. If nil, a key will be generated.
  /// - Returns: The cached or newly generated values.
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
  
  /// Clears all cached values.
  public mutating func reset() {
    values.removeAll()
  }
}

/// A high-level interface for generating and caching random values.
///
/// This generator provides a convenient way to work with cached random values
/// while abstracting away the details of cache management.
public struct RandomValueGenerator<T: RandomGeneratable> {
  private var cache: RandomCache<T>
  
  /// Creates a new generator with a specified seed.
  /// - Parameter seed: The seed value for the random number generator.
  public init(seed: UInt64) {
    self.cache = RandomCache(seed: seed)
  }
  
  /// Generates or retrieves cached random values.
  /// - Parameters:
  ///   - count: The number of random values needed.
  ///   - parameters: Parameters influencing the generation.
  ///   - cacheKey: Optional custom key for caching.
  /// - Returns: The generated or cached values.
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
  
  /// Resets the internal cache.
  public mutating func reset() {
    cache.reset()
  }
}

/// A random number generator that produces consistent results based on a seed value.
public struct SeededGenerator: RandomNumberGenerator {
  /// Creates a new seeded generator.
  /// - Parameter seed: The seed value for the generator.
  public init(seed: UInt64) {
    srand48(Int(seed))
  }
  
  /// Generates the next random value.
  /// - Returns: A random UInt64 value.
  public func next() -> UInt64 {
    UInt64(drand48() * Double(UInt64.max))
  }
}

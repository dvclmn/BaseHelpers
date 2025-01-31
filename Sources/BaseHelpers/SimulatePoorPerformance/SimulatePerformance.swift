//
//  SimulatePerformance.swift
//  Collection
//
//  Created by Dave Coleman on 26/1/2025.
//

import Foundation

/// Simulate delays and potential failures
/// ```
/// func simulateWork(
///   type: String,
///   config: SimulationConfig
/// ) async throws {
///   try await Task.sleep(nanoseconds: UInt64(config.networkDelay * 1_000_000_000))
///
///   if Double.random(in: 0...1) < config.failureRate {
///     throw SimulationError.randomFailure(type)
///   }
/// }
/// ```
/// Allows us to simulate different network and processing conditions
public struct SimulationConfig: Sendable {
  public let networkDelay: TimeInterval
  public let processingDelay: TimeInterval
  public let failureRate: Double // 0.0 to 1.0
  public let batchSize: Int
  
  public static let fast = SimulationConfig(
    networkDelay: 0.1,
    processingDelay: 0.05,
    failureRate: 0.0,
    batchSize: 50
  )
  
  public static let slow = SimulationConfig(
    networkDelay: 2.0,
    processingDelay: 1.0,
    failureRate: 0.1,
    batchSize: 10
  )
}

public enum SimulationError: LocalizedError, Error {
  case randomFailure(String)

}

//
//  TaskRepeater.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 10/9/2025.
//

import Foundation

//@MainActor
//final class RepeatingTask {
//  /// Runs the given action repeatedly, with the given interval, until cancelled.
//  func execute(
//    interval: TimeInterval = 1,
//    action: @escaping @MainActor () -> Void
//  ) async {
//    while !Task.isCancelled {
//      try? await Task.sleep(for: .seconds(interval))
//      action()
//    }
//  }
//}

public struct RepeatingTask {
  public static func run(
    interval: TimeInterval = 1,
    action: @escaping @MainActor () -> Void
  ) async {
    while !Task.isCancelled {
      try? await Task.sleep(for: .seconds(interval))
      await action()
    }
  }
  
  public static func run(
    interval: TimeInterval = 1,
    action: @escaping @MainActor () async -> Void
  ) async {
    while !Task.isCancelled {
      try? await Task.sleep(for: .seconds(interval))
      await action()
    }
  }
}

public struct RepeatingStream {
  public static func stream<T: Sendable>(
    interval: TimeInterval = 1,
    produce: @escaping @MainActor () -> T
  ) -> AsyncStream<T> {
    AsyncStream { continuation in
      Task {
        while !Task.isCancelled {
          try? await Task.sleep(for: .seconds(interval))
          await continuation.yield(produce())
        }
        continuation.finish()
      }
    }
  }
  
  public static func stream<T: Sendable>(
    interval: TimeInterval = 1,
    produce: @escaping @MainActor () async -> T
  ) -> AsyncStream<T> {
    AsyncStream { continuation in
      Task {
        while !Task.isCancelled {
          try? await Task.sleep(for: .seconds(interval))
          continuation.yield(await produce())
        }
        continuation.finish()
      }
    }
  }
}

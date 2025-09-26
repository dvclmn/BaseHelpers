//
//  TaskRepeater.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 10/9/2025.
//

import Foundation

// MARK: - Repeating Single Task

public struct RepeatingTask {
  
  /// Synchronous action version
  public static func run(
    interval: TimeInterval = 1,
    action: @escaping @MainActor () -> Void
  ) async {
    /// Run immediately for the first time
    await action()

    /// Then continue with the delayed loop
    while !Task.isCancelled {
      try? await Task.sleep(for: .seconds(interval))
      await action()
    }
  }

  /// Async action version
  public static func run(
    interval: TimeInterval = 1,
    action: @escaping @MainActor () async -> Void
  ) async {
    /// Run immediately for the first time
    await action()

    /// Then continue with the delayed loop
    while !Task.isCancelled {
      try? await Task.sleep(for: .seconds(interval))
      await action()
    }
  }
}

// MARK: - Repeating Stream
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

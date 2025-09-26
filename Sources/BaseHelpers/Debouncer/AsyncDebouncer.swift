//
//  AsyncDebouncer.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 2/3/2025.
//

import Foundation

/// Important note: Don't use the one debouncer instance for
/// two distinct tasks, or one may cancel the other. Use seperate instances.
@MainActor
public final class AsyncDebouncer {
  private var task: Task<Void, Never>? = nil
  private let interval: Duration

  public init(interval: CGFloat) {
    self.interval = Duration.seconds(interval)
  }

  /// Execute a debounced async task that returns a value
  public func execute<T: Sendable>(
    action: @escaping @Sendable () async -> T?
  ) async -> T? {

    /// Cancel any previous task
    task?.cancel()

    return await withCheckedContinuation { cont in
      task = Task { [interval, action] in
        try? await Task.sleep(for: interval)
        guard !Task.isCancelled else {
          cont.resume(returning: nil)
          return
        }
        cont.resume(returning: await action())
      }
    }
  }

  deinit {
    task?.cancel()
  }
}

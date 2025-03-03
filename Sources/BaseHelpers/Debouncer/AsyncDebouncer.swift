//
//  AsyncDebouncer.swift
//  BaseHelpers
//
//  Created by Dave Coleman on 2/3/2025.
//

@MainActor
public final class AsyncDebouncer {
  private var task: Task<Void, Never>? = nil
  private let interval: Duration

  public init(interval: Duration = .seconds(0.2)) {
    self.interval = interval
  }

  /// Execute a debounced async task that returns a value
  public func execute<T: Sendable>(
    action: @escaping @Sendable () async -> T?
  ) async -> T? {
    /// Cancel any previous task
    task?.cancel()

    /// Create a new task with the work
    return await withCheckedContinuation { continuation in
      task = Task { [weak self, action] in
        guard let self = self else {
          continuation.resume(returning: nil)
          return
        }

        do {
          /// Wait for the debounce interval
          try await Task.sleep(for: self.interval)

          /// If task wasn't cancelled during the wait, execute the action
          if !Task.isCancelled {
            let result = await action()
            continuation.resume(returning: result)
          } else {
            continuation.resume(returning: nil)
          }
        } catch {
          continuation.resume(returning: nil)
        }
      }
    }
  }

  deinit {
    task?.cancel()
  }
}

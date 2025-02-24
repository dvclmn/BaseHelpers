//
//  Debouncer.swift
//  Utilities
//
//  Created by Dave Coleman on 25/8/2024.
//

import Foundation
import SwiftUI

@MainActor
public final class Debouncer<T: Equatable> {
  
  /// The current (debounced) value.
  ///
  /// When updated to a new, different value, this property not only triggers the
  /// `valueChanged` callback (if set) but also yields the new value on `asyncStream`.
  public private(set) var value: T {
    didSet {
      guard oldValue != value else { return }
      // Notify observers via the callback.
      valueChanged?(value)
      // Yield to the asynchronous stream.
      streamContinuation?.yield(value)
    }
  }
  
  /// Callback invoked when the debounced value is updated.
  public var valueChanged: ((T) -> Void)?
  
  /// The task waiting to update the stored value.
  private var updateTask: Task<Void, Never>?
  
  /// The task waiting to execute a generic asynchronous action.
  private var genericTask: Task<Void, Never>?
  
  /// The debounce interval.
  private let interval: Duration
  
  /// The continuation used to feed new values into the async stream.
  private var streamContinuation: AsyncStream<T>.Continuation?
  
  /// An asynchronous sequence of debounced value updates.
  ///
  /// Use this to observe value changes as an async stream. For example:
  ///
  ///     let debouncer = Debouncer("Initial", interval: .seconds(0.2))
  ///     Task {
  ///         for await newValue in debouncer.asyncStream {
  ///             print("New value: \(newValue)")
  ///         }
  ///     }
  public lazy var asyncStream: AsyncStream<T> = AsyncStream { [weak self] continuation in
    guard let self = self else {
      continuation.finish()
      return
    }
    self.streamContinuation = continuation
  }
  
  /// Creates a new Debouncer with an initial value and a debounce interval.
  ///
  /// - Parameters:
  ///   - value: The initial value.
  ///   - interval: The time to wait after the last update (or action) before executing it.
  ///               Defaults to 0.2 seconds.
  public init(_ value: T, interval: Duration = .seconds(0.2)) {
    self.value = value
    self.interval = interval
  }
  
  /// Debounces a value update.
  ///
  /// If `newValue` is different from the current value, any pending update is cancelled
  /// and the update is scheduled after the debounce interval. When the update ultimately
  /// happens, the internal value is modified—triggering the callback and the async stream.
  ///
  /// - Parameter newValue: The new value to commit.
  public func update(with newValue: T) {
    guard newValue != value else { return }
    updateTask?.cancel()
    updateTask = Task { [weak self] in
      guard let self = self else { return }
      do {
        try await Task.sleep(for: self.interval)
        if !Task.isCancelled {
          self.value = newValue
        }
      } catch {
        // Task was cancelled or an error occurred; ignore.
      }
    }
  }
  
  /// Debounces an arbitrary asynchronous action.
  ///
  /// This method schedules an asynchronous closure to execute after the debounce delay.
  /// If a new action is scheduled before the delay expires, the previously scheduled action
  /// is cancelled.
  ///
  /// - Parameter action: An asynchronous closure that will be executed after the debounce delay.
  public func processTask(action: @escaping @Sendable () async -> Void) {
    genericTask?.cancel()
    genericTask = Task { [weak self, action] in
      guard let self = self else { return }
      do {
        try await Task.sleep(for: self.interval)
        if !Task.isCancelled {
          await action()
        }
      } catch {
        // Task cancelled or error occurred; no further processing is needed.
      }
    }
  }
  
  deinit {
    updateTask?.cancel()
    genericTask?.cancel()
    streamContinuation?.finish()
  }
}

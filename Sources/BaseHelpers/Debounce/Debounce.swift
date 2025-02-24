//
//  Debouncer.swift
//  Utilities
//
//  Created by Dave Coleman on 25/8/2024.
//

import Foundation
import SwiftUI


@MainActor
public final class DebounceValue<T: Equatable> {
  
  /// The latest debounced value.
  ///
  /// When updated, if the new value is different from the previous
  /// one, the change triggers both the `valueChanged` callback (if set)
  /// and is yielded on `asyncStream`.
  private(set) var value: T {
    didSet {
      guard oldValue != value else { return }
      // Notify the callback, if provided.
      valueChanged?(value)
      // Yield the updated value on the async stream.
      streamContinuation?.yield(value)
    }
  }
  
  /// A callback that is invoked every time the debounced value is updated.
  public var valueChanged: ((T) -> Void)?
  
  /// The task currently waiting during the debounce interval.
  private var task: Task<Void, Never>?
  
  /// The debounce interval.
  private let interval: Duration
  
  /// The AsyncStream continuation used to yield debounced values.
  private var streamContinuation: AsyncStream<T>.Continuation?
  
  /// An asynchronous sequence of debounced values.
  ///
  /// You can use this property to write code such as:
  ///
  ///     let debouncer = DebounceValue("Initial", interval: .seconds(0.2))
  ///     Task {
  ///         for await newValue in debouncer.asyncStream {
  ///             print("Value updated: \(newValue)")
  ///         }
  ///     }
  ///
  /// Note that this stream is meant to be used by a single consumer.
  public lazy var asyncStream: AsyncStream<T> = AsyncStream { [weak self] continuation in
    guard let self = self else {
      continuation.finish()
      return
    }
    self.streamContinuation = continuation
  }
  
  /// Creates a new `DebounceValue` with an initial value and debounce interval.
  ///
  /// - Parameters:
  ///   - value: The initial value.
  ///   - interval: The debounce interval. Default is 0.2 seconds.
  public init(_ value: T, interval: Duration = .seconds(0.2)) {
    self.value = value
    self.interval = interval
  }
  
  /// Schedules an update with the given new value.
  ///
  /// If the new value is different from the current one, this method schedules an update
  /// after the specified debounce interval. If a new update is scheduled before the interval
  /// has elapsed, the previous pending update is cancelled.
  ///
  /// - Parameter newValue: The new value to update with.
  public func update(with newValue: T) {
    guard newValue != value else { return }
    // Cancel any previously scheduled update.
    task?.cancel()
    task = Task { [weak self] in
      guard let self = self else { return }
      do {
        try await Task.sleep(for: self.interval)
        if !Task.isCancelled {
          // This triggers didSet which calls the callback and yields to asyncStream.
          self.value = newValue
        }
      } catch {
        // Task was cancelled; no further action needed.
      }
    }
  }
  
  deinit {
    task?.cancel()
    // Finish the async stream when the debouncer is deallocated.
    streamContinuation?.finish()
  }
}


/// A debounced value container that updates its stored value only after a quiet period.
///
/// When `update(with:)` is called with a new value, the update is delayed by the specified
/// interval. If another update arrives during this interval, the previous update is cancelled.
/// Setting `valueChanged` allows you to get notified when the debounced update finally occurs.
///
/// Example:
///     let debounced = DebounceValue("Initial", interval: .milliseconds(300))
///     debounced.valueChanged = { newValue in
///         print("Value updated: \(newValue)")
///     }
///     debounced.update(with: "New Value")
//@MainActor
//public final class DebounceValue<T: Equatable> {
//
//  private(set) var value: T {
//    didSet {
//      guard oldValue != value else { return }
//      valueChanged?(value)
//    }
//  }
//
//  var valueChanged: ((T) -> Void)?
//
//  private var task: Task<Void, Never>?
//  private let interval: Duration
//  //  private let scheduler: DebounceScheduler
//
//  public init(
//    _ value: T,
//    interval: Duration = .seconds(0.2)
//    //    scheduler: DebounceScheduler = MainScheduler()
//  ) {
//    self.value = value
//    self.interval = interval
//    //    self.scheduler = scheduler
//  }
//
//  public func update(with newValue: T) {
//    guard newValue != value else { return }
//    task?.cancel()
//    task = Task { [weak self] in
//      guard let self else { return }
//      do {
//        try await Task.sleep(for: self.interval)
//        if !Task.isCancelled {
//          self.value = newValue
//        }
//      } catch {
//        // Task cancelled, no action needed
//      }
//    }
//  }
//
//  deinit {
//    task?.cancel()
//  }
//}
//
///// Protocol for testing and dependency injection
//public protocol DebounceScheduler {
//  func schedule(for duration: Duration) async throws
//}

/// Default implementation using Task.sleep
//public struct MainScheduler: DebounceScheduler {
//  public func schedule(for duration: Duration) async throws {
//    try await Task.sleep(for: duration)
//  }
//  public init
//}

/// Example usage (seems like this could be improved)
///
/// ```
///    Task {
///      await heightHandler.processTask { [weak self] in
///
///        guard let self = self else { return }
///
///        let height = await self.generateEditorHeight()
///
///        Task { @MainActor in
///          await self.infoHandler.update(height)
///        }
///
///      } // END process scroll
///    } // END Task
/// ```
///
//public actor Debouncer {
//  private var task: Task<Void, Never>?
//  private let interval: TimeInterval
//
//  public init(interval: TimeInterval = 0.1) {
//    self.interval = interval
//  }
//
//  public func processTask(action: @escaping @Sendable () async -> Void) {
//    task?.cancel()
//    task = Task { [weak self, action] in
//      guard let self = self else { return }
//      do {
//        try await Task.sleep(for: .seconds(self.interval))
//        if !Task.isCancelled {
//          await action()
//        }
//      } catch {
//        // Handle cancellation or other errors
//      }
//    }
//  }
//}
//


//@MainActor
//public final class DebounceValue<T> {
//  private var task: Task<Void, Never>?
//  private let interval: Duration
//  private var lastValue: T?
//  private let action: (T) -> Void
//
//  public init(
//    interval: Duration = .seconds(0.2),
//    action: @Sendable @escaping (T) -> Void
//  ) {
//    self.interval = interval
//    self.action = action
//  }
//
//  public func send(_ value: T) {
//    lastValue = value
//    task?.cancel()
//    task = Task { [weak self] in
//      guard let self = self else { return }
//      do {
//        try await Task.sleep(for: self.interval)
//        if !Task.isCancelled, let value = self.lastValue {
//          self.action(value)
//        }
//      } catch {
//        // Task cancelled, no action needed
//      }
//    }
//  }
//
//  deinit {
//    task?.cancel()
//  }
//}
